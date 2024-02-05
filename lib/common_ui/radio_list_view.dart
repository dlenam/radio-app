import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/common_ui/custom_network_image.dart';
import 'package:radio_app/common_ui/custom_page_routes.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/features/radio_player/view/radio_player_screen.dart';
import 'package:radio_app/features/widgets/favorite_icon.dart';
import 'package:radio_app/infra/theme.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioListView extends StatelessWidget {
  final RadioList radioList;
  final ScrollController? controller;
  final bool shouldRemoveItemWhenUnfavorite;

  RadioListView({
    super.key,
    this.controller,
    required this.radioList,
    this.shouldRemoveItemWhenUnfavorite = false,
  });

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: AnimatedList(
        key: _listKey,
        controller: controller,
        shrinkWrap: true,
        initialItemCount: radioList.length + 1,
        itemBuilder: (context, index, animation) {
          if (index == 0) {
            // Add a pading that doesn't screw the scrolling nor the animation
            return const SizedBox(height: 10);
          }
          final radioStation = radioList[index - 1];
          return BlocBuilder<RadioFavoritesCubit, RadioFavoritesState>(
            buildWhen: (previous, current) =>
                previous.isFavorite(radioStation.id) !=
                current.isFavorite(radioStation.id),
            builder: (context, state) {
              final isFavorite = state.isFavorite(radioStation.id);
              return _AnimatedListItem(
                isFavorite: state.isFavorite(radioStation.id),
                radioStation: radioStation,
                animation: animation,
                onTap: () {
                  _handleFavorite(
                    index: index,
                    radioStation: radioStation,
                    isFavorite: isFavorite,
                    radioFavoritesCubit: context.read<RadioFavoritesCubit>(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _handleFavorite({
    required int index,
    required RadioStation radioStation,
    required bool isFavorite,
    required RadioFavoritesCubit radioFavoritesCubit,
  }) async {
    if (isFavorite) {
      if (shouldRemoveItemWhenUnfavorite) {
        await _removeFromListWithAnimation(
          index: index,
          radioStation: radioStation,
        );
      }
      radioFavoritesCubit.removeFavorite(radioStation);
      return;
    }
    radioFavoritesCubit.addFavorite(radioStation);
  }

  Future<void> _removeFromListWithAnimation({
    required int index,
    required RadioStation radioStation,
  }) {
    final completer = Completer();
    _listKey.currentState!.removeItem(
      index,
      // Widget that is displayed while removing
      (_, animation) => _AnimatedListItem(
        isFavorite: true,
        radioStation: radioStation,
        animation: animation
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.dismissed) {
                completer.complete();
              }
            },
          ),
        // We don't need to capture the onTap, as we don't want the user to
        // interact with the animation
        onTap: () {},
      ),
      duration: const Duration(milliseconds: 300),
    );
    return completer.future;
  }
}

class _AnimatedListItem extends StatelessWidget {
  final RadioStation radioStation;
  final bool isFavorite;
  final VoidCallback onTap;
  final Animation<double> animation;

  const _AnimatedListItem({
    required this.radioStation,
    required this.isFavorite,
    required this.onTap,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          color: appTheme.standardBackgroundColor,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            onTap: () => Navigator.of(context).push(
              bottomToTopTransitionPage(
                RadioPlayerScreen(radioStation: radioStation),
              ),
            ),
            leading: CustomNetworkImage(
              imageUrl: radioStation.iconUrl,
              radius: 10,
              fixedDefaultImageWidth: 50,
            ),
            title: Text(
              radioStation.name ?? 'Unknown station',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FavoriteIcon(
              onTap: onTap,
              isFavorite: isFavorite,
            ),
          ),
        ),
      ),
    );
  }
}

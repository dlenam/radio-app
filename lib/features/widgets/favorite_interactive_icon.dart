import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/model/radio_station.dart';
import 'package:radio_app/theme.dart';

class FavoriteInteractiveIcon extends StatelessWidget {
  final RadioStation radioStation;

  const FavoriteInteractiveIcon({super.key, required this.radioStation});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioFavoritesCubit, RadioFavoritesState>(
      buildWhen: (previous, current) =>
          previous.isFavorite(radioStation.id) !=
          current.isFavorite(radioStation.id),
      builder: (context, state) {
        final isFavorites = state.isFavorite(radioStation.id);
        return GestureDetector(
            child: isFavorites
                ? const CustomIcon(icon: Icons.favorite)
                : const CustomIcon(icon: Icons.favorite_border_outlined),
            onTap: () {
              isFavorites
                  ? context
                      .read<RadioFavoritesCubit>()
                      .removeFavorite(radioStation)
                  : context
                      .read<RadioFavoritesCubit>()
                      .addFavorite(radioStation);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(_buildSnackBar(isFavorites));
            });
      },
    );
  }
}

SnackBar _buildSnackBar(bool isFavorite) => SnackBar(
      backgroundColor: primaryColor,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
            child: Text(isFavorite
                ? 'Removed from favorites!'
                : 'Added to favourites!')),
      ),
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

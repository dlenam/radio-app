import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/common_ui/custom_network_image.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_player_widget.dart';
import 'package:radio_app/features/widgets/favorite_icon.dart';
import 'package:radio_app/infra/theme.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioPlayerScreen extends StatefulWidget {
  final RadioStation radioStation;

  const RadioPlayerScreen({super.key, required this.radioStation});

  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = GetIt.instance.get<RadioFavoritesCubit>();
    return Scaffold(
      backgroundColor: appTheme.standardBackgroundColor,
      appBar: AppBar(
        backgroundColor: appTheme.standardBackgroundColor,
        title: Center(
          child: Text(
            widget.radioStation.name ?? 'Unknown station',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: appTheme.primaryColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const CustomIcon(
              icon: Icons.keyboard_arrow_down_rounded,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: BlocBuilder<RadioFavoritesCubit, RadioFavoritesState>(
              bloc: cubit,
              builder: (context, state) {
                final isFavorite = state.isFavorite(widget.radioStation.id);
                return FavoriteIcon(
                  onTap: () {
                    isFavorite
                        ? cubit.removeFavorite(widget.radioStation)
                        : cubit.addFavorite(widget.radioStation);
                  },
                  isFavorite: isFavorite,
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomNetworkImage(
                imageUrl: widget.radioStation.iconUrl,
                fixedDefaultImageWidth: 300,
              ),
            ),
            Expanded(
              child: AudioPlayerWidget(radioStation: widget.radioStation),
            ),
          ],
        ),
      ),
    );
  }
}

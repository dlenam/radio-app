import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_metadata_title.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_player_button.dart';
import 'package:radio_app/features/radio_player/view/widgets/audio_volume_slider.dart';
import 'package:radio_app/model/radio_station.dart';

class AudioPlayerWidget extends StatelessWidget {
  final RadioStation radioStation;

  const AudioPlayerWidget({super.key, required this.radioStation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RadioPlayerCubit>(
      create: (_) =>
          GetIt.instance.get<RadioPlayerCubit>()..startStreaming(radioStation),
      child: const _AudioPlayerView(),
    );
  }
}

class _AudioPlayerView extends StatefulWidget {
  const _AudioPlayerView();

  @override
  State<_AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<_AudioPlayerView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<RadioPlayerCubit>().pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RadioPlayerCubit, RadioPlayerState>(
      listener: (context, state) {
        // TODO: do something about the errors
      },
      child: const SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: AudioPlayerButton()),
            AudioVolumeSlider(),
            SizedBox(height: 50),
            SizedBox(
              height: 100,
              child: AudioMetadataTitle(),
            )
          ],
        ),
      ),
    );
  }
}

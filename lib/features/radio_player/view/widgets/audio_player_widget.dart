import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';
import 'package:radio_app/theme.dart';

class AudioPlayer extends StatelessWidget {
  final String streamUrl;

  const AudioPlayer({super.key, required this.streamUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RadioPlayerCubit>(
      create: (_) =>
          GetIt.instance.get<RadioPlayerCubit>()..startStreaming(streamUrl),
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
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
                buildWhen: (previous, current) => previous.type != current.type,
                builder: (_, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AudioPlayerButton(state.type),
                  ],
                ),
              ),
            ),
            BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
              buildWhen: (previous, current) =>
                  previous.volume != current.volume,
              builder: (context, state) => _VolumeSlider(
                value: state.volume,
                onChanged: context.read<RadioPlayerCubit>().volumeChanged,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 100,
              child: BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
                buildWhen: (previous, current) =>
                    previous.radioMetadataTitle != current.radioMetadataTitle,
                builder: (_, state) {
                  return state.radioMetadataTitle != null
                      ? _AudioMetadataTitle(title: state.radioMetadataTitle!)
                      : Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final double? value;
  final Function(double) onChanged;

  const _VolumeSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return Container();
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // const Icon(Icons.volume_up_rounded, size: 40),
        const CustomIcon(icon: Icons.volume_up_rounded),
        Expanded(
          child: Slider(
            min: 0,
            max: 1,
            value: value!,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        )
      ],
    );
  }
}

class _AudioPlayerButton extends StatelessWidget {
  final RadioPlayerStateType radioPlayerStatus;

  const _AudioPlayerButton(this.radioPlayerStatus);

  @override
  Widget build(BuildContext context) {
    switch (radioPlayerStatus) {
      case RadioPlayerStateType.loading:
        return Container(
          margin: const EdgeInsets.all(8.0),
          width: 64.0,
          height: 64.0,
          child: const CircularProgressIndicator(color: primaryColor),
        );
      case RadioPlayerStateType.playing:
        return IconButton(
          icon: const Icon(Icons.pause_circle),
          iconSize: 64.0,
          onPressed: context.read<RadioPlayerCubit>().pause,
          color: primaryColor,
        );
      case RadioPlayerStateType.stopped:
      case RadioPlayerStateType.error:
        return IconButton(
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: 64.0,
          onPressed: () => context.read<RadioPlayerCubit>().play(),
          color: primaryColor,
        );
    }
  }
}

class _AudioMetadataTitle extends StatelessWidget {
  final String title;
  const _AudioMetadataTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            title,
            textAlign: TextAlign.center,
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontFamily: 'Horizon',
            ),
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
          )
        ],
      ),
    );
  }
}

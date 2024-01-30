import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';

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
    return BlocConsumer<RadioPlayerCubit, RadioPlayerState>(
      listener: (context, state) {
        // TODO: do something about the errors
      },
      builder: (context, state) {
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: _AudioPlayerButton(state.type)),
              const SizedBox(height: 50),
              SizedBox(
                height: 100,
                child: state.radioMetadataTitle != null
                    ? _AudioMetadataTitle(title: state.radioMetadataTitle!)
                    : Container(),
              )
            ],
          ),
        );
      },
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
          child: const CircularProgressIndicator(),
        );
      case RadioPlayerStateType.playing:
        return IconButton(
          icon: const Icon(Icons.pause),
          iconSize: 64.0,
          onPressed: () => context.read<RadioPlayerCubit>().pause(),
        );
      case RadioPlayerStateType.stopped:
      case RadioPlayerStateType.error:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          iconSize: 64.0,
          onPressed: () => context.read<RadioPlayerCubit>().play(),
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

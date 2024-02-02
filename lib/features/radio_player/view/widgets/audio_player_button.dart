import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';
import 'package:radio_app/infra/theme.dart';

class AudioPlayerButton extends StatelessWidget {
  const AudioPlayerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
      buildWhen: (previous, current) => previous.type != current.type,
      builder: (_, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AudioPlayerButtonContent(state.type),
        ],
      ),
    );
  }
}

class _AudioPlayerButtonContent extends StatelessWidget {
  final RadioPlayerStateType radioPlayerStatus;

  final double _buttonSize = 64;
  const _AudioPlayerButtonContent(this.radioPlayerStatus);

  @override
  Widget build(BuildContext context) {
    switch (radioPlayerStatus) {
      case RadioPlayerStateType.loading:
        return Container(
          margin: const EdgeInsets.all(8.0),
          width: _buttonSize,
          height: _buttonSize,
          child: CircularProgressIndicator(color: appTheme.primaryColor),
        );
      case RadioPlayerStateType.playing:
        return IconButton(
          icon: const Icon(Icons.pause_circle),
          iconSize: _buttonSize,
          onPressed: context.read<RadioPlayerCubit>().pause,
          color: appTheme.primaryColor,
        );
      case RadioPlayerStateType.stopped:
      case RadioPlayerStateType.error:
        return IconButton(
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: _buttonSize,
          onPressed: () => context.read<RadioPlayerCubit>().play(),
          color: appTheme.primaryColor,
        );
    }
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';

class AudioMetadataTitle extends StatelessWidget {
  const AudioMetadataTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
      buildWhen: (previous, current) =>
          previous.radioMetadataTitle != current.radioMetadataTitle,
      builder: (_, state) {
        if (state.radioMetadataTitle == null) {
          return Container();
        }
        return SizedBox(
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                state.radioMetadataTitle!,
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
      },
    );
  }
}

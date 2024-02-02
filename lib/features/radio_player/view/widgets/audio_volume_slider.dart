import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/common_ui/custom_icon.dart';
import 'package:radio_app/features/radio_player/cubit/radio_player_cubit.dart';
import 'package:radio_app/theme.dart';

class AudioVolumeSlider extends StatelessWidget {
  const AudioVolumeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioPlayerCubit, RadioPlayerState>(
      buildWhen: (previous, current) => previous.volume != current.volume,
      builder: (context, state) => state.volume == null
          ? Container()
          : Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const CustomIcon(icon: Icons.volume_up_rounded),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 1,
                    value: state.volume!,
                    onChanged: context.read<RadioPlayerCubit>().volumeChanged,
                    activeColor: appTheme.primaryColor,
                  ),
                )
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/features/radio_home/view/widgets/radio_list_widget.dart';

class RadioFavoritesTab extends StatelessWidget {
  const RadioFavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioFavoritesCubit, RadioFavoritesState>(
      builder: (context, state) {
        return RadioListWidget(
          radioList: state.favoriteList,
        );
      },
    );
  }
}

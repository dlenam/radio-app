import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_app/features/radio_favorites/data/radio_favorites_repository.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioFavoritesCubit extends Cubit<RadioFavoritesState> {
  final RadioFavoritesRepository favoritesRepository;

  late StreamSubscription _favoritesRepoSubscription;

  RadioFavoritesCubit(this.favoritesRepository)
      : super(RadioFavoritesState(favoritesRepository.favoritesValue)) {
    _favoritesRepoSubscription =
        favoritesRepository.favoritesStream.listen((favorites) {
      emit(RadioFavoritesState(favorites));
    });
  }

  void addFavorite(RadioStation radioStation) {
    favoritesRepository
        .updateFavorites([...favoritesRepository.favoritesValue, radioStation]);
  }

  void removeFavorite(RadioStation radioStation) {
    final newFavorites = [...favoritesRepository.favoritesValue];
    final wasRemoved = newFavorites.remove(radioStation);
    if (!wasRemoved) {
      // Tried removing a favorite that is not...be careful ;)
      return;
    }
    // No need to emit a new state, the repository stream will take care.
    favoritesRepository.updateFavorites(newFavorites);
  }

  @override
  Future<void> close() {
    _favoritesRepoSubscription.cancel();
    return super.close();
  }
}

class RadioFavoritesState extends Equatable {
  final RadioList favoriteList;

  const RadioFavoritesState(this.favoriteList);

  bool isFavorite(String radioId) {
    for (var radio in favoriteList) {
      if (radio.id == radioId) {
        return true;
      }
    }
    return false;
  }

  @override
  List<Object?> get props => [favoriteList];
}

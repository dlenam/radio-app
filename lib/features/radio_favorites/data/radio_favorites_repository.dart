import 'package:radio_app/features/radio_favorites/data/radio_favorites_data_source.dart';
import 'package:radio_app/model/radio_station.dart';
import 'package:rxdart/rxdart.dart';

class RadioFavoritesRepository {
  final RadioFavoritesDataSource _radioFavoritesDataSource;
  final BehaviorSubject<List<RadioStation>> _favorites;

  RadioFavoritesRepository(this._radioFavoritesDataSource)
      : _favorites = BehaviorSubject<List<RadioStation>>.seeded(
            _radioFavoritesDataSource.get());

  void updateFavorites(List<RadioStation> favorites) {
    _favorites.add(favorites);
    _radioFavoritesDataSource.set(favorites);
  }

  Stream<List<RadioStation>> get favoritesStream => _favorites.stream;

  List<RadioStation> get favoritesValue => _favorites.value;
}

import 'dart:convert';

import 'package:radio_app/model/radio_station.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioFavoritesDataSource {
  final SharedPreferences _preferences;

  static const String _key = 'favorites_keys';
  RadioFavoritesDataSource(this._preferences);

  RadioList get() {
    final serialisedFavorites = _preferences.getString(_key);
    if (serialisedFavorites != null) {
      return jsonDecode(serialisedFavorites)
          .map<RadioStation>(
              (favoriteJson) => RadioStation.fromJson(favoriteJson))
          .toList();
    }
    return [];
  }

  void set(RadioList favoriteList) {
    final serialisedFavorites =
        jsonEncode(favoriteList.map((favorite) => favorite.toJson()).toList());
    _preferences.setString(_key, serialisedFavorites);
  }
}

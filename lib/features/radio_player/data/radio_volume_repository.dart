import 'package:shared_preferences/shared_preferences.dart';

class RadioVolumeRepository {
  final SharedPreferences _preferences;

  final String _key = 'volume_key';
  RadioVolumeRepository(this._preferences);

  double? getVolume() => _preferences.getDouble(_key);

  void storeVolume(double value) => _preferences.setDouble(_key, value);
}

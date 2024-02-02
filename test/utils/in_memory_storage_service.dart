import 'package:shared_preferences/shared_preferences.dart';

class InMemoryStorageService implements SharedPreferences {
  final Map<String, String> memory;

  InMemoryStorageService({Map<String, String>? initial})
      : memory = initial ?? <String, String>{};

  @override
  String? getString(String key) {
    return memory[key];
  }

  @override
  Future<bool> setString(String key, String value) async {
    memory[key] = value;
    return true;
  }

  @override
  double? getDouble(String key) {
    return memory[key] != null ? double.parse(memory[key]!) : null;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    memory[key] = value.toString();
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

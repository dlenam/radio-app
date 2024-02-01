import 'dart:convert';

import 'package:http/http.dart';
import 'package:radio_app/model/radio_station.dart';

const _radioAPIUrl = '65.109.136.86';

class RadioStationApiDataSource {
  final Client http;

  const RadioStationApiDataSource(this.http);

  Future<RadioList> getRadios({required int offset, int limit = 10}) async {
    final url = Uri.https(_radioAPIUrl, '/json/stations/search', {
      'offset': offset.toString(),
      'limit': limit.toString(),
      'is_https': 'true'
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((json) => RadioStation.fromApiJson(json))
          .toList();
    }
    throw Exception('Unknown http error');
  }
}

import 'package:radio_app/features/radio_home/data/radio_station_api_data_source.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioStationRepository {
  final RadioStationApiDataSource _radioStationApiClient;

  RadioStationRepository(
      {required RadioStationApiDataSource radioStationApiClient})
      : _radioStationApiClient = radioStationApiClient;

  final int _stationsBatchAmount = 15;
  final RadioList _loadedRadioStations = [];

  int _stationsLoadedOffset = 0;

  Future<RadioList> loadMoreAndGetRadioStations() async {
    final nextRadioStationList = await _radioStationApiClient.getRadios(
      offset: _stationsLoadedOffset,
      limit: _stationsBatchAmount,
    );
    _stationsLoadedOffset += _stationsBatchAmount;
    _loadedRadioStations.addAll(nextRadioStationList);
    return _loadedRadioStations;
  }
}

import 'package:radio_app/features/radio_list/data/radio_station_data_source.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioStationRepository {
  final RadioStationDataSource _radioStationApiClient;

  RadioStationRepository(
      {required RadioStationDataSource radioStationApiClient})
      : _radioStationApiClient = radioStationApiClient;

  final int _stationsBatchAmount = 15;
  final List<RadioStation> _loadedRadioStations = [];

  int _stationsLoadedOffset = 0;

  Future<List<RadioStation>> loadMoreAndGetRadioStations() async {
    final nextRadioStationList = await _radioStationApiClient.getRadios(
      offset: _stationsLoadedOffset,
      limit: _stationsBatchAmount,
    );
    _stationsLoadedOffset += _stationsBatchAmount;
    _loadedRadioStations.addAll(nextRadioStationList);
    return _loadedRadioStations;
  }
}

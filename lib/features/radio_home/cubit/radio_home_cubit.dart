import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/features/radio_home/data/radio_station_repository.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioHomeCubit extends Cubit<RadioHomeState> {
  final RadioStationRepository _radioStationRepository;

  RadioHomeCubit({required RadioStationRepository radioStationRepository})
      : _radioStationRepository = radioStationRepository,
        super(RadioHomeState.initial());

  void loadMoreRadioStations() async {
    if (state.status == RadioListStatus.loading) {
      return;
    }
    emit(RadioHomeState.loading(radioList: state.radioList));
    final results = await Future.wait([
      _radioStationRepository.loadMoreAndGetRadioStations(),
      // Fake duration to see the loader
      Future.delayed(const Duration(seconds: 1))
    ]);
    emit(RadioHomeState.loaded(radioList: results[0]));
  }
}

enum RadioListStatus { initial, loading, loaded, error }

@immutable
class RadioHomeState {
  final RadioListStatus status;
  final RadioList radioList;

  const RadioHomeState._({required this.status, required this.radioList});

  factory RadioHomeState.initial() =>
      const RadioHomeState._(status: RadioListStatus.initial, radioList: []);

  const RadioHomeState.loading({required this.radioList})
      : status = RadioListStatus.loading;

  const RadioHomeState.loaded({required this.radioList})
      : status = RadioListStatus.loaded;
}

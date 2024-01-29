import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/features/radio_list/data/radio_station_repository.dart';
import 'package:radio_app/features/radio_list/model/radio_station.dart';

class RadioStationListCubit extends Cubit<RadioListState> {
  final RadioStationRepository _radioStationRepository;

  RadioStationListCubit(
      {required RadioStationRepository radioStationRepository})
      : _radioStationRepository = radioStationRepository,
        super(RadioListState.initial());

  void loadMoreRadioStations() async {
    if (state.status == RadioListStatus.loading) {
      return;
    }
    emit(RadioListState.loading(radioList: state.radioList));
    final results = await Future.wait([
      _radioStationRepository.loadMoreAndGetRadioStations(),
      // Fake duration to see the loader
      Future.delayed(const Duration(seconds: 1))
    ]);
    emit(RadioListState.loaded(radioList: results[0]));
  }
}

enum RadioListStatus { initial, loading, loaded, error }

@immutable
class RadioListState {
  final RadioListStatus status;
  final List<RadioStation> radioList;

  const RadioListState._({required this.status, required this.radioList});

  factory RadioListState.initial() =>
      const RadioListState._(status: RadioListStatus.initial, radioList: []);

  const RadioListState.loading({required this.radioList})
      : status = RadioListStatus.loading;

  const RadioListState.loaded({required this.radioList})
      : status = RadioListStatus.loaded;
}

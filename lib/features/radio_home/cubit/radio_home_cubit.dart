import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:radio_app/features/radio_home/data/radio_station_repository.dart';
import 'package:radio_app/model/radio_station.dart';

class RadioHomeCubit extends Cubit<RadioHomeState> {
  final RadioStationRepository _radioStationRepository;

  RadioHomeCubit({required RadioStationRepository radioStationRepository})
      : _radioStationRepository = radioStationRepository,
        super(const RadioHomeState.initial());

  void loadMoreRadioStations() async {
    if (state.status == RadioListStatus.loading) {
      return;
    }
    emit(RadioHomeState.loading(radioList: state.radioList));
    try {
      final results = await Future.wait([
        _radioStationRepository.loadMoreAndGetRadioStations(),
        // Fake duration to see the loader
        Future.delayed(const Duration(seconds: 1))
      ]);
      emit(RadioHomeState.loaded(radioList: results[0]));
    } catch (e) {
      emit(RadioHomeState.error(radioList: state.radioList));
    }
  }
}

enum RadioListStatus { initial, loading, loaded, error }

@immutable
class RadioHomeState extends Equatable {
  final RadioListStatus status;
  final RadioList radioList;

  const RadioHomeState.initial()
      : status = RadioListStatus.initial,
        radioList = const [];

  const RadioHomeState.loading({required this.radioList})
      : status = RadioListStatus.loading;

  const RadioHomeState.loaded({required this.radioList})
      : status = RadioListStatus.loaded;

  const RadioHomeState.error({required this.radioList})
      : status = RadioListStatus.error;

  bool get shouldDisplayErrorScreen =>
      status == RadioListStatus.error && radioList.isEmpty;

  bool get shouldDisplayLoading =>
      status == RadioListStatus.loading || status == RadioListStatus.initial;

  @override
  List<Object?> get props => [status, radioList];
}

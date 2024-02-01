import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_app/features/radio_player/data/radio_volume_repository.dart';

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final AudioSession _audioSession;
  final AudioPlayer _audioPlayer;
  final RadioVolumeRepository _radioVolumeRepository;

  StreamSubscription? _errorSubscription;
  StreamSubscription? _mainPlayerSubscription;
  StreamSubscription? _metadataSubscription;
  StreamSubscription? _volumeSubscription;

  RadioPlayerCubit({
    required RadioVolumeRepository radioVolumeRepository,
    required AudioSession audioSession,
    required AudioPlayer audioPlayer,
  })  : _radioVolumeRepository = radioVolumeRepository,
        _audioSession = audioSession,
        _audioPlayer = audioPlayer,
        super(
          const RadioPlayerState(
            type: RadioPlayerStateType.loading,
            volume: null,
          ),
        );

  void startStreaming(String streamUrl) async {
    try {
      await _configureRadio(
        streamUrl: streamUrl,
        audioPlayer: _audioPlayer,
        audioSession: _audioSession,
      );
      _errorSubscription = _startErrorListener(_audioPlayer);
      _metadataSubscription = _startMetadataListener(_audioPlayer);
      _mainPlayerSubscription = _startPlayerStateListener(_audioPlayer);
      _volumeSubscription = _startVolumeListener(_audioPlayer);
    } on Exception catch (e) {
      print('Some error happened with the player $e');
      emit(state.copyWith(type: RadioPlayerStateType.error));
    }
  }

  Future<void> _configureRadio({
    required String streamUrl,
    required AudioSession audioSession,
    required AudioPlayer audioPlayer,
  }) async {
    await audioSession.configure(const AudioSessionConfiguration.speech());
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(streamUrl)));
    final initialVolume = _radioVolumeRepository.getVolume();
    if (initialVolume != null) {
      audioPlayer.setVolume(initialVolume);
    }
  }

  StreamSubscription<double> _startVolumeListener(AudioPlayer player) =>
      player.volumeStream.listen((volume) {
        emit(state.copyWith(volume: volume));
      });

  StreamSubscription<PlaybackEvent> _startErrorListener(AudioPlayer player) =>
      player.playbackEventStream.listen(
        (event) {
          // An error ocurred while playing the stream
        },
      );

  StreamSubscription<PlayerState> _startPlayerStateListener(
          AudioPlayer player) =>
      player.playerStateStream.listen((event) {
        switch (event.processingState) {
          case ProcessingState.loading:
          case ProcessingState.buffering:
            emit(state.copyWith(type: RadioPlayerStateType.stopped));
            return;
          default:
          // Probably some states we don't care for radios.
        }
        emit(
          state.copyWith(
            type: event.playing
                ? RadioPlayerStateType.playing
                : RadioPlayerStateType.stopped,
          ),
        );
      });

  StreamSubscription<IcyMetadata?> _startMetadataListener(AudioPlayer player) =>
      player.icyMetadataStream.listen((event) {
        final radioMetadataTitle = event?.info?.title;
        if (radioMetadataTitle != null) {
          emit(state.copyWith(radioMetadataTitle: radioMetadataTitle));
        }
      });

  void volumeChanged(double value) {
    _audioPlayer.setVolume(value);
    _radioVolumeRepository.storeVolume(value);
  }

  void pause() {
    _audioPlayer.pause();
  }

  void play() {
    _audioPlayer.play();
  }

  @override
  Future<void> close() async {
    _errorSubscription?.cancel();
    _mainPlayerSubscription?.cancel();
    _metadataSubscription?.cancel();
    _volumeSubscription?.cancel();
    _audioPlayer.dispose();
    await super.close();
  }
}

enum RadioPlayerStateType { loading, playing, stopped, error }

@immutable
class RadioPlayerState extends Equatable {
  final RadioPlayerStateType type;
  final String? radioMetadataTitle;
  // Null volume means it hasn't loaded yet.
  final double? volume;

  const RadioPlayerState({
    required this.type,
    this.radioMetadataTitle,
    required this.volume,
  });

  RadioPlayerState copyWith({
    String? radioMetadataTitle,
    RadioPlayerStateType? type,
    double? volume,
  }) =>
      RadioPlayerState(
        type: type ?? this.type,
        radioMetadataTitle: radioMetadataTitle ?? this.radioMetadataTitle,
        volume: volume ?? this.volume,
      );

  @override
  List<Object?> get props => [type, radioMetadataTitle, volume];
}

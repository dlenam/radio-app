import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

typedef AudioSessioGetter = Future<AudioSession> Function();

class RadioPlayerCubit extends Cubit<RadioPlayerState> {
  final AudioSessioGetter _audioSessionGetter;
  final AudioPlayer _player;

  late StreamSubscription _errorSubscription;
  late StreamSubscription _mainPlayerSubscription;
  late StreamSubscription _metadataStream;

  RadioPlayerCubit(
      {required AudioSessioGetter audioSessionGetter,
      required AudioPlayer player})
      : _audioSessionGetter = audioSessionGetter,
        _player = player,
        super(const RadioPlayerState(type: RadioPlayerStateType.loading));

  void startStreaming(String streamUrl) async {
    try {
      final audioSession = await _audioSessionGetter();
      await audioSession.configure(const AudioSessionConfiguration.speech());
      await _player.setAudioSource(AudioSource.uri(Uri.parse(streamUrl)));
      _errorSubscription = _player.playbackEventStream.listen(
        (event) {
          // An error ocurred while playing the stream
        },
      );
      _metadataStream = _player.icyMetadataStream.listen((event) {
        final radioMetadataTitle = event?.info?.title;
        if (radioMetadataTitle != null) {
          emit(state.copyWith(radioMetadataTitle: radioMetadataTitle));
        }
      });
      _mainPlayerSubscription = _player.playerStateStream.listen((event) {
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
    } on Exception catch (e) {
      print('Some erro happened with the player $e');
      emit(state.copyWith(type: RadioPlayerStateType.error));
    }
  }

  void pause() {
    _player.pause();
  }

  void play() {
    _player.play();
  }

  @override
  Future<void> close() async {
    _errorSubscription.cancel();
    _mainPlayerSubscription.cancel();
    _metadataStream.cancel();
    _player.dispose();
    await super.close();
  }
}

enum RadioPlayerStateType { loading, playing, stopped, error }

@immutable
class RadioPlayerState extends Equatable {
  final RadioPlayerStateType type;
  final String? radioMetadataTitle;

  const RadioPlayerState({
    required this.type,
    this.radioMetadataTitle,
  });

  RadioPlayerState copyWith(
          {String? radioMetadataTitle, RadioPlayerStateType? type}) =>
      RadioPlayerState(
        type: type ?? this.type,
        radioMetadataTitle: radioMetadataTitle ?? this.radioMetadataTitle,
      );

  @override
  List<Object?> get props => [type, radioMetadataTitle];
}

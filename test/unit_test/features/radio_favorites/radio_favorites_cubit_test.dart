import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:radio_app/features/radio_favorites/cubit/radio_favorites_cubit.dart';
import 'package:radio_app/features/radio_favorites/data/radio_favorites_repository.dart';
import 'package:radio_app/model/radio_station.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('RadioFavoritesCubit should', () {
    blocTest<RadioFavoritesCubit, RadioFavoritesState>(
      'emits the right initial favorite radios',
      build: () {
        final favoritesRepository = RadioFavoriteRepositoryMock();
        when(() => favoritesRepository.favoritesStream)
            .thenAnswer((_) => Stream.value([_fakeRadioStation1]));
        when(() => favoritesRepository.favoritesValue)
            .thenAnswer((_) => [_fakeRadioStation1]);
        return RadioFavoritesCubit(favoritesRepository);
      },
      verify: (bloc) => expect(
        bloc.state,
        const RadioFavoritesState([_fakeRadioStation1]),
      ),
    );

    blocTest<RadioFavoritesCubit, RadioFavoritesState>(
      'emits the last added favorites',
      build: () {
        final favoritesRepository = RadioFavoriteRepositoryMock();
        final behaviorSubject = BehaviorSubject<List<RadioStation>>();
        when(() => favoritesRepository.favoritesStream)
            .thenAnswer((_) => behaviorSubject);
        when(() => favoritesRepository.favoritesValue)
            .thenAnswer((_) => behaviorSubject.value);
        behaviorSubject.add([_fakeRadioStation1]);
        when(() => favoritesRepository.updateFavorites(any())).thenAnswer(
            (invocation) =>
                behaviorSubject.add(invocation.positionalArguments[0]));
        return RadioFavoritesCubit(favoritesRepository);
      },
      act: (bloc) {
        bloc.addFavorite(_fakeRadioStatio2);
      },
      verify: (bloc) => expect(
        bloc.state,
        const RadioFavoritesState([_fakeRadioStation1, _fakeRadioStatio2]),
      ),
    );

    blocTest<RadioFavoritesCubit, RadioFavoritesState>(
      'emits the right final favorites',
      build: () {
        final favoritesRepository = RadioFavoriteRepositoryMock();
        final behaviorSubject = BehaviorSubject<List<RadioStation>>();
        when(() => favoritesRepository.favoritesStream)
            .thenAnswer((_) => behaviorSubject);
        when(() => favoritesRepository.favoritesValue)
            .thenAnswer((_) => behaviorSubject.value);
        behaviorSubject.add([_fakeRadioStation1]);
        when(() => favoritesRepository.updateFavorites(any())).thenAnswer(
            (invocation) =>
                behaviorSubject.add(invocation.positionalArguments[0]));
        return RadioFavoritesCubit(favoritesRepository);
      },
      act: (bloc) {
        bloc.removeFavorite(_fakeRadioStation1);
        bloc.addFavorite(_fakeRadioStatio2);
      },
      verify: (bloc) => expect(
        bloc.state,
        const RadioFavoritesState([_fakeRadioStatio2]),
      ),
    );
  });
}

const _fakeRadioStation1 = RadioStation(
  id: 'id-1',
  name: 'name',
  country: 'country',
  streamUrl: 'https//whatever',
  iconUrl: 'https//whatever-2',
);

const _fakeRadioStatio2 = RadioStation(
  id: 'id-2',
  name: 'name',
  country: 'country',
  streamUrl: 'https//whatever',
  iconUrl: 'https//whatever-2',
);

class RadioFavoriteRepositoryMock extends Mock
    implements RadioFavoritesRepository {}

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_series/tv_series.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTVSeries,
  GetPopularTVSeries,
  GetTopRatedTVSeries,
])
void main() {
  late TVSeriesListNotifier notifier;
  late MockGetAiringTodayTVSeries mockGetAiringTodayTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late int listenerCallCount;

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTVSeries = MockGetAiringTodayTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    notifier =
        TVSeriesListNotifier(
          getTVSeriesAiringToday: mockGetAiringTodayTVSeries,
          getPopularTVSeries: mockGetPopularTVSeries,
          getTopRatedTVSeries: mockGetTopRatedTVSeries,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  group('airing today', () {
    test('initialState should be Empty', () {
      expect(notifier.airingTodayState, RequestState.Empty);
    });
    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetAiringTodayTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchAiringTodayTVSeries();
      // assert
      verify(mockGetAiringTodayTVSeries.execute());
    });
    test('should change state to Loading when usecase is called', () {
      // arrange
      when(
        mockGetAiringTodayTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      notifier.fetchAiringTodayTVSeries();
      // assert
      expect(notifier.airingTodayState, RequestState.Loading);
    });

    test('should change tv series when data is gotten successfully', () async {
      // arrange
      when(
        mockGetAiringTodayTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchAiringTodayTVSeries();
      // assert
      expect(notifier.airingTodayState, RequestState.Loaded);
      expect(notifier.airingTodayTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetAiringTodayTVSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchAiringTodayTVSeries();
      // assert
      expect(notifier.airingTodayState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular', () {
    test('initialState should be Empty', () {
      expect(notifier.popularState, RequestState.Empty);
    });
    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchPopularTVSeries();
      // assert
      verify(mockGetPopularTVSeries.execute());
    });
    test('should change state to Loading when usecase is called', () {
      // arrange
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      notifier.fetchPopularTVSeries();
      // assert
      expect(notifier.popularState, RequestState.Loading);
    });
    test('should change tv series when data is gotten successfully', () async {
      // arrange
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchPopularTVSeries();
      // assert
      expect(notifier.popularState, RequestState.Loaded);
      expect(notifier.popularTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchPopularTVSeries();
      // assert
      expect(notifier.popularState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated', () {
    test('initialState should be Empty', () {
      expect(notifier.topRatedState, RequestState.Empty);
    });
    test('should get data from the usecase', () async {
      // arrange
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchTopRatedTVSeries();
      // assert
      verify(mockGetTopRatedTVSeries.execute());
    });
    test('should change state to Loading when usecase is called', () {
      // arrange
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      notifier.fetchTopRatedTVSeries();
      // assert
      expect(notifier.topRatedState, RequestState.Loading);
    });
    test('should change tv series when data is gotten successfully', () async {
      // arrange
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      await notifier.fetchTopRatedTVSeries();
      // assert
      expect(notifier.topRatedState, RequestState.Loaded);
      expect(notifier.topRatedTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchTopRatedTVSeries();
      // assert
      expect(notifier.topRatedState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

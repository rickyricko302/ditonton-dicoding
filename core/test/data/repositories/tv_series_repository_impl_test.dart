import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final TVSeriesModel tTVSeriesModel = TVSeriesModel(
    backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
    firstAirDate: "2023-01-23",
    genreIds: [9648, 18],
    id: 202250,
    name: "Dirty Linen",
    originCountry: ["PH"],
    originalLanguage: "tl",
    originalName: "Dirty Linen",
    overview:
        "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
    popularity: 2797.914,
    posterPath: "/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg",
    voteAverage: 5,
    voteCount: 13,
  );

  final tTVSeriesModelList = <TVSeriesModel>[tTVSeriesModel];

  final TVSeries tTVSeries = tTVSeriesModel.toEntity();
  final tTVSeriesList = <TVSeries>[tTVSeries];

  group('Airing Today', () {
    test(
      'should return tv series list when success call remote data',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAiringTodayTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getAiringTodayTVSeries();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTVSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call remote data is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getAiringTodayTVSeries(),
        ).thenThrow(Exception());
        // act
        final result = await repository.getAiringTodayTVSeries();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTVSeries());
        expect(result.isLeft(), true);
      },
    );
  });

  group('Popular', () {
    test(
      'should return tv series list when success call remote data',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getPopularTVSeries();
        // assert
        verify(mockRemoteDataSource.getPopularTVSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call remote data is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTVSeries()).thenThrow(Exception());
        // act
        final result = await repository.getPopularTVSeries();
        // assert
        verify(mockRemoteDataSource.getPopularTVSeries());
        expect(result.isLeft(), true);
      },
    );
  });

  group('Top Rated', () {
    test(
      'should return tv series list when success call remote data',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        // act
        final result = await repository.getTopRatedTVSeries();
        // assert
        verify(mockRemoteDataSource.getTopRatedTVSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call remote data is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTVSeries()).thenThrow(Exception());
        // act
        final result = await repository.getTopRatedTVSeries();
        // assert
        verify(mockRemoteDataSource.getTopRatedTVSeries());
        expect(result.isLeft(), true);
      },
    );
  });

  group('TV Series Detail', () {
    final tTVSeriesDetailModel = TVSeriesDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );
    test(
      'should return tv series detail when success call remote data',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeriesDetail(1),
        ).thenAnswer((_) async => tTVSeriesDetailModel);
        // act
        final result = await repository.getTVSeriesDetail(1);
        // assert
        verify(mockRemoteDataSource.getTVSeriesDetail(1));
        final resultDetail = result.getOrElse(() => throw Exception());
        expect(resultDetail, tTVSeriesDetailModel.toEntity());
      },
    );

    // list recommendations tv series
    test(
      'should return list recommendations tv series when success call remote data',
      () async {
        // arrange
        final tTVSeriesList = TVSeriesResponse.fromJson(
          json.decode(readJson('dummy_data/tv_series_recommendations.json')),
        ).tvSeriesList;
        when(
          mockRemoteDataSource.getTVSeriesRecommendations(1),
        ).thenAnswer((_) async => tTVSeriesList);
        // act
        final result = await repository.getTVSeriesRecommendations(1);
        // assert
        verify(mockRemoteDataSource.getTVSeriesRecommendations(1));
        final resultList = result.getOrElse(() => []);
        expect(
          resultList,
          tTVSeriesList.map((model) => model.toEntity()).toList(),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(
        mockLocalDataSource.getTVSeriesById(tId),
      ).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TV Series', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesTable]);
      // act
      final result = await repository.getWatchlistTVSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTVSeriesTable.toEntity()]);
    });
  });
}

// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'dart:convert';

import 'package:core/data/datasources/tv_series_remote_data_source.dart';
import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:core/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = ApiConfig.API_KEY;
  const BASE_URL = ApiConfig.BASE_URL;

  late TVSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('Now Playing TV Series', () {
    final tMovieList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_airing_today.json')),
    ).tvSeriesList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_airing_today.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getAiringTodayTVSeries();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getAiringTodayTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Popular TV Series', () {
    final tMovieList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_popular.json')),
    ).tvSeriesList;

    test(
      'should return list of Movie Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series_popular.json'), 200),
        );
        // act
        final result = await dataSource.getPopularTVSeries();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('Top Rated TV Series', () {
    final tMovieList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_top_rated.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_top_rated.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTopRatedTVSeries();
        // assert
        expect(result, equals(tMovieList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTVSeries();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('TV Series Detail', () {
    final tMovieDetail = TVSeriesDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );
    test('should return TV Series Detail Model when success', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/1?$API_KEY'))).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
      );
      // act
      final result = await dataSource.getTVSeriesDetail(1);
      // assert
      expect(result, equals(tMovieDetail));
    });

    test(
      'should return list recommendations tv series model when success',
      () async {
        // arrange
        final tTVSeriesList = TVSeriesResponse.fromJson(
          json.decode(readJson('dummy_data/tv_series_recommendations.json')),
        ).tvSeriesList;
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/1/recommendations?$API_KEY'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_recommendations.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getTVSeriesRecommendations(1);
        // assert
        expect(result, equals(tTVSeriesList));
      },
    );
  });
}

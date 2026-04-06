import 'package:core/data/models/tv_series_model.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVSeriesModel = TVSeriesModel(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of TVSeries entity', () async {
    final result = tTVSeriesModel.toEntity();
    expect(result, tTVSeries);
  });

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap = {
      "backdrop_path": 'backdropPath',
      "first_air_date": 'firstAirDate',
      "genre_ids": [1, 2, 3],
      "id": 1,
      "name": 'name',
      "origin_country": ['originCountry'],
      "original_language": 'originalLanguage',
      "original_name": 'originalName',
      "overview": 'overview',
      "popularity": 1.0,
      "poster_path": 'posterPath',
      "vote_average": 1.0,
      "vote_count": 1,
    };
    // act
    final result = TVSeriesModel.fromJson(jsonMap);
    // assert
    expect(result, tTVSeriesModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTVSeriesModel.toJson();
    // assert
    final expectedJsonMap = {
      "backdrop_path": 'backdropPath',
      "first_air_date": 'firstAirDate',
      "genre_ids": [1, 2, 3],
      "id": 1,
      "name": 'name',
      "origin_country": ['originCountry'],
      "original_language": 'originalLanguage',
      "original_name": 'originalName',
      "overview": 'overview',
      "popularity": 1.0,
      "poster_path": 'posterPath',
      "vote_average": 1.0,
      "vote_count": 1,
    };
    expect(result, expectedJsonMap);
  });
}

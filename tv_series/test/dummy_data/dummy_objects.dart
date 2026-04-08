import 'package:core/core.dart';

final testTVSeries = TVSeries(
  backdropPath: 'backdropPath',
  firstAirDate: 'firstAirDate',
  genreIds: [1, 2, 3],
  id: 1,
  name: 'name',
  originCountry: ['originCountry'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1.0,
  posterPath: 'posterPath',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = TVSeriesDetail(
  backdropPath: 'backdropPath',
  firstAirDate: 'firstAirDate',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1.0,
  seasons: [
    TVSeriesSeason(
      airDate: '2023-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'Overview for Season 1',
      posterPath: 'posterPath',
      seasonNumber: 1,
      voteAverage: 8.0,
    ),
  ],
  numberOfEpisodes: 1,
);

final testTVSeriesTable = TVSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVSeriesMap = {
  'id': 1,
  'title': 'name',
  'overview': 'overview',
  'posterPath': 'posterPath',
};

final testWatchlistTVSeries = TVSeries(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

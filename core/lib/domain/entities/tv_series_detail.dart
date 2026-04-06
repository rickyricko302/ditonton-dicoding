import 'package:core/domain/entities/genre.dart';
import 'package:equatable/equatable.dart';

import 'tv_series_season.dart';

class TVSeriesDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String firstAirDate;
  final List<Genre> genres;
  final List<TVSeriesSeason> seasons;
  final int? numberOfEpisodes;

  const TVSeriesDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.firstAirDate,
    required this.genres,
    required this.seasons,
    required this.numberOfEpisodes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    firstAirDate,
    genres,
    seasons,
    numberOfEpisodes,
  ];
}

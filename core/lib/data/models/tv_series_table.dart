import 'package:core/core.dart';

import 'package:core/data/models/tv_series_model.dart';
import 'package:core/data/models/watchlist_table.dart';
import 'package:core/domain/entities/tv_series_detail.dart';

import '../../domain/entities/tv_series.dart';

class TVSeriesTable extends Equatable implements WatchlistTable {
  @override
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  const TVSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TVSeriesTable.fromEntity(TVSeriesDetail tvSeries) => TVSeriesTable(
    id: tvSeries.id,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  factory TVSeriesTable.fromMap(Map<String, dynamic> map) => TVSeriesTable(
    id: map['id'],
    name: map['name'] ?? map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
  );

  factory TVSeriesTable.fromDTO(TVSeriesModel tvSeries) => TVSeriesTable(
    id: tvSeries.id ?? 0,
    name: tvSeries.name,
    posterPath: tvSeries.posterPath,
    overview: tvSeries.overview,
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': name,
    'posterPath': posterPath,
    'overview': overview,
    'category': kWatchlistCategoryTVSeries,
  };

  TVSeries toEntity() =>
      TVSeries(id: id, overview: overview, posterPath: posterPath, name: name);

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}

import 'package:dartz/dartz.dart';

import 'package:core/core.dart';
import '../entities/tv_series_detail.dart';
import '../repositories/tv_series_repository.dart';

class RemoveWatchlistTVSeries {
  final TVSeriesRepository repository;

  RemoveWatchlistTVSeries(this.repository);
  Future<Either<Failure, String>> execute(TVSeriesDetail tvSeries) {
    return repository.removeWatchlist(tvSeries);
  }
}

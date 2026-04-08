import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class RemoveWatchlistTVSeries {
  final TVSeriesRepository repository;

  RemoveWatchlistTVSeries(this.repository);
  Future<Either<Failure, String>> execute(TVSeriesDetail tvSeries) {
    return repository.removeWatchlist(tvSeries);
  }
}

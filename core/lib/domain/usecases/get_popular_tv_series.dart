import 'package:dartz/dartz.dart';

import 'package:core/core.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetPopularTVSeries {
  final TVSeriesRepository repository;

  GetPopularTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getPopularTVSeries();
  }
}

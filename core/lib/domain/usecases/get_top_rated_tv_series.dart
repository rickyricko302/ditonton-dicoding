import 'package:dartz/dartz.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';

import 'package:core/core.dart';
import '../entities/tv_series.dart';

class GetTopRatedTVSeries {
  final TVSeriesRepository repository;

  GetTopRatedTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getTopRatedTVSeries();
  }
}

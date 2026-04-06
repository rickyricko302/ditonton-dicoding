import 'package:dartz/dartz.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/core.dart';

import '../entities/tv_series.dart';

class GetAiringTodayTVSeries {
  final TVSeriesRepository repository;

  GetAiringTodayTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getAiringTodayTVSeries();
  }
}

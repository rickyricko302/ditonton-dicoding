import 'package:dartz/dartz.dart';

import 'package:core/core.dart';
import '../entities/tv_series.dart';
import '../repositories/tv_series_repository.dart';

class GetRecommendationsTVSeries {
  final TVSeriesRepository repository;

  GetRecommendationsTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(int id) {
    return repository.getTVSeriesRecommendations(id);
  }
}

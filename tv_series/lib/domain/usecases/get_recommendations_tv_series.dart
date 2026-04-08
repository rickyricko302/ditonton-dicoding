import 'package:dartz/dartz.dart';

import 'package:core/core.dart';

class GetRecommendationsTVSeries {
  final TVSeriesRepository repository;

  GetRecommendationsTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(int id) {
    return repository.getTVSeriesRecommendations(id);
  }
}

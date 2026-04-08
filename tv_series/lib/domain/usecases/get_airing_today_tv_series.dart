import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

class GetAiringTodayTVSeries {
  final TVSeriesRepository repository;

  GetAiringTodayTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getAiringTodayTVSeries();
  }
}

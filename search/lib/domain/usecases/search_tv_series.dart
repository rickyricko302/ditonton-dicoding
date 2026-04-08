import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class SearchTVSeries {
  final TVSeriesRepository repository;

  SearchTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(String query) {
    return repository.searchTVSeries(query);
  }
}

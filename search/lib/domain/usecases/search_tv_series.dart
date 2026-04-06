import 'package:core/domain/entities/tv_series.dart';

import 'package:core/core.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:dartz/dartz.dart';

class SearchTVSeries {
  final TVSeriesRepository repository;

  SearchTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute(String query) {
    return repository.searchTVSeries(query);
  }
}

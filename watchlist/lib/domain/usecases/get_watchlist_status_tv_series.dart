import 'package:core/domain/repositories/tv_series_repository.dart';

class GetWatchlistStatusTVSeries {
  final TVSeriesRepository repository;

  GetWatchlistStatusTVSeries(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}

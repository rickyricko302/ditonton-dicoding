import 'package:core/core.dart';
import 'package:core/data/services/watchlist_service.dart';
import 'package:dartz/dartz.dart';

import '../../domain/usecases/get_watchlist_status.dart';
import '../../domain/usecases/get_watchlist_status_tv_series.dart';
import '../../domain/usecases/remove_watchlist.dart';
import '../../domain/usecases/remove_watchlist_tv_series.dart';
import '../../domain/usecases/save_watchlist.dart';
import '../../domain/usecases/save_watchlist_tv_series.dart';

class WatchlistServiceImpl implements WatchlistService {
  final GetWatchListStatus getWatchlistStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final SaveWatchlistTVSeries saveWatchlistTVSeries;
  final GetWatchlistStatusTVSeries getWatchlistStatusTVSeries;
  final RemoveWatchlistTVSeries removeWatchlistTVSeries;

  WatchlistServiceImpl({
    required this.getWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.saveWatchlistTVSeries,
    required this.getWatchlistStatusTVSeries,
    required this.removeWatchlistTVSeries,
  });

  @override
  Future<Either<Failure, String>> addMovieWatchlist(MovieDetail movie) {
    return saveWatchlist.execute(movie);
  }

  @override
  Future<bool> loadWatchlistStatus(int id) {
    return getWatchlistStatus.execute(id);
  }

  @override
  Future<Either<Failure, String>> removeMovieWatchlist(MovieDetail movie) {
    return removeWatchlist.execute(movie);
  }

  @override
  Future<Either<Failure, String>> addTvSeriesWatchlist(
    TVSeriesDetail tvSeries,
  ) {
    return saveWatchlistTVSeries.execute(tvSeries);
  }

  @override
  Future<bool> loadTvSeriesWatchlistStatus(int id) {
    return getWatchlistStatusTVSeries.execute(id);
  }

  @override
  Future<Either<Failure, String>> removeTvSeriesWatchlist(
    TVSeriesDetail tvSeries,
  ) {
    return removeWatchlistTVSeries.execute(tvSeries);
  }
}

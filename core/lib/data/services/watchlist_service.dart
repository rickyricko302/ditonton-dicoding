import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

abstract class WatchlistService {
  // movie
  Future<Either<Failure, String>> addMovieWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> removeMovieWatchlist(MovieDetail movie);
  Future<bool> loadWatchlistStatus(int id);
  // tv series
  Future<Either<Failure, String>> addTvSeriesWatchlist(TVSeriesDetail movie);
  Future<Either<Failure, String>> removeTvSeriesWatchlist(TVSeriesDetail movie);
  Future<bool> loadTvSeriesWatchlistStatus(int id);
}

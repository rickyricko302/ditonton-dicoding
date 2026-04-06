import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_watchlist_tv_series.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({
    required this.getWatchlistMovies,
    required this.getWatchlistTVSeries,
  });

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTVSeries getWatchlistTVSeries;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  RequestState _watchlistTVSeriesState = RequestState.Empty;
  RequestState get watchlistTVSeriesState => _watchlistTVSeriesState;

  String _messageTVSeries = '';
  String get messageTVSeries => _messageTVSeries;

  List<TVSeries> _watchlistTVSeries = [];
  List<TVSeries> get watchlistTVSeries => _watchlistTVSeries;

  Future<void> fetchWatchlistTVSeries() async {
    _watchlistTVSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTVSeries.execute();
    result.fold(
      (failure) {
        _watchlistTVSeriesState = RequestState.Error;
        _messageTVSeries = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _watchlistTVSeriesState = RequestState.Loaded;
        _watchlistTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}

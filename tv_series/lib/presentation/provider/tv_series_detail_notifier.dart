import 'package:core/core.dart';
import 'package:core/data/services/watchlist_service.dart';
import '../../domain/usecases/get_recommendations_tv_series.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import 'package:flutter/material.dart';

class TVSeriesDetailNotifier extends ChangeNotifier {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetRecommendationsTVSeries getRecommendationsTVSeries;

  final WatchlistService watchlistService;

  late TVSeriesDetail _tvSeriesDetail;
  TVSeriesDetail get tvSeriesDetail => _tvSeriesDetail;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  TVSeriesDetailNotifier({
    required this.getTVSeriesDetail,
    required this.getRecommendationsTVSeries,
    required this.watchlistService,
  });

  Future<void> fetchTVSeriesDetail(int id) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTVSeriesDetail.execute(id);
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesDetail) {
        _tvSeriesDetail = tvSeriesDetail;
        _state = RequestState.Loaded;
        _message = 'Success';
        notifyListeners();
      },
    );
  }

  late List<TVSeries> _recommendations;
  List<TVSeries> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.Empty;
  RequestState get recommendationsState => _recommendationsState;

  Future<void> fetchTVSeriesRecommendations(int id) async {
    _recommendationsState = RequestState.Loading;
    notifyListeners();

    final result = await getRecommendationsTVSeries.execute(id);
    result.fold(
      (failure) {
        _recommendationsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _recommendations = tvSeries;
        _recommendationsState = RequestState.Loaded;
        _message = 'Success';
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVSeriesDetail tvSeries) async {
    final result = await watchlistService.addTvSeriesWatchlist(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
        loadWatchlistStatus(tvSeries.id);
        notifyListeners();
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
        loadWatchlistStatus(tvSeries.id);
        notifyListeners();
      },
    );
  }

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> loadWatchlistStatus(int id) async {
    final result = await watchlistService.loadTvSeriesWatchlistStatus(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }

  Future<void> removeFromWatchlist(TVSeriesDetail tvSeries) async {
    final result = await watchlistService.removeTvSeriesWatchlist(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
        loadWatchlistStatus(tvSeries.id);
        notifyListeners();
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
        loadWatchlistStatus(tvSeries.id);
        notifyListeners();
      },
    );
  }
}

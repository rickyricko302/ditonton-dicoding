import 'package:flutter/material.dart';

import 'package:core/core.dart';
import '../../domain/usecases/get_airing_today_tv_series.dart';
import '../../domain/usecases/get_popular_tv_series.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

class TVSeriesListNotifier extends ChangeNotifier {
  final GetAiringTodayTVSeries _getAiringTodayTVSeries;
  final GetPopularTVSeries _getPopularTVSeries;
  final GetTopRatedTVSeries _getTopRatedTVSeries;
  TVSeriesListNotifier({
    required GetAiringTodayTVSeries getTVSeriesAiringToday,
    required GetPopularTVSeries getPopularTVSeries,
    required GetTopRatedTVSeries getTopRatedTVSeries,
  }) : _getAiringTodayTVSeries = getTVSeriesAiringToday,
       _getPopularTVSeries = getPopularTVSeries,
       _getTopRatedTVSeries = getTopRatedTVSeries;

  RequestState _airingTodayState = RequestState.Empty;
  RequestState get airingTodayState => _airingTodayState;

  List<TVSeries> _airingTodayTVSeries = [];
  List<TVSeries> get airingTodayTVSeries => _airingTodayTVSeries;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  List<TVSeries> _popularTVSeries = [];
  List<TVSeries> get popularTVSeries => _popularTVSeries;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  List<TVSeries> _topRatedTVSeries = [];
  List<TVSeries> get topRatedTVSeries => _topRatedTVSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchAiringTodayTVSeries() async {
    _airingTodayState = RequestState.Loading;
    notifyListeners();
    final result = await _getAiringTodayTVSeries.execute();

    result.fold(
      (failure) {
        _airingTodayState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _airingTodayState = RequestState.Loaded;
        _airingTodayTVSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVSeries() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await _getPopularTVSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _popularState = RequestState.Loaded;
        _popularTVSeries = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await _getTopRatedTVSeries.execute();
    result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _topRatedState = RequestState.Loaded;
        _topRatedTVSeries = data;
        notifyListeners();
      },
    );
  }
}

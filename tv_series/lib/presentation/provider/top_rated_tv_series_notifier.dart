import 'package:flutter/material.dart';

import 'package:core/core.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

class TopRatedTVSeriesNotifier extends ChangeNotifier {
  var _topRatedTVSeries = <TVSeries>[];
  List<TVSeries> get topRatedTVSeries => _topRatedTVSeries;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;
  TopRatedTVSeriesNotifier({required this.getTopRatedTVSeries});
  final GetTopRatedTVSeries getTopRatedTVSeries;

  Future<void> fetchTopRatedTVSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _state = RequestState.Loaded;
        _topRatedTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}

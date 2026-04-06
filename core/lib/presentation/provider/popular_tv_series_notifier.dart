import 'dart:core';

import 'package:flutter/widgets.dart';

import 'package:core/core.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/get_popular_tv_series.dart';

class PopularTVSeriesNotifier extends ChangeNotifier {
  var _popularTVSeries = <TVSeries>[];
  List<TVSeries> get popularTVSeries => _popularTVSeries;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  PopularTVSeriesNotifier({required this.getPopularTVSeries});

  final GetPopularTVSeries getPopularTVSeries;

  Future<void> fetchPopularTVSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVSeries.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _state = RequestState.Loaded;
        _popularTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}

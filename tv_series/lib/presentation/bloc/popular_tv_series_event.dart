import 'package:core/core.dart';

abstract class PopularTVSeriesEvent extends Equatable {
  const PopularTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTVSeries extends PopularTVSeriesEvent {}

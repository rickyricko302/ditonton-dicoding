import 'package:core/core.dart';

abstract class TopRatedTVSeriesEvent extends Equatable {
  const TopRatedTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTVSeries extends TopRatedTVSeriesEvent {}

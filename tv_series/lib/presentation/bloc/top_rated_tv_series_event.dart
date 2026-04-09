import 'package:equatable/equatable.dart';

abstract class TopRatedTVSeriesEvent extends Equatable {
  const TopRatedTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTVSeries extends TopRatedTVSeriesEvent {}

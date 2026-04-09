import 'package:equatable/equatable.dart';

abstract class PopularTVSeriesEvent extends Equatable {
  const PopularTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTVSeries extends PopularTVSeriesEvent {}

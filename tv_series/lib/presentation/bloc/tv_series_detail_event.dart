import 'package:core/core.dart';

abstract class TVSeriesDetailEvent extends Equatable {
  const TVSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVSeriesDetail extends TVSeriesDetailEvent {
  final int id;

  const FetchTVSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistTVSeries extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  const AddWatchlistTVSeries(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveFromWatchlistTVSeries extends TVSeriesDetailEvent {
  final TVSeriesDetail tvSeriesDetail;

  const RemoveFromWatchlistTVSeries(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class LoadWatchlistStatusTVSeries extends TVSeriesDetailEvent {
  final int id;

  const LoadWatchlistStatusTVSeries(this.id);

  @override
  List<Object> get props => [id];
}

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class TopRatedTVSeriesState extends Equatable {
  const TopRatedTVSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTVSeriesEmpty extends TopRatedTVSeriesState {
  const TopRatedTVSeriesEmpty();
}

class TopRatedTVSeriesLoading extends TopRatedTVSeriesState {
  const TopRatedTVSeriesLoading();
}

class TopRatedTVSeriesError extends TopRatedTVSeriesState {
  final String message;

  const TopRatedTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTVSeriesHasData extends TopRatedTVSeriesState {
  final List<TVSeries> result;

  const TopRatedTVSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

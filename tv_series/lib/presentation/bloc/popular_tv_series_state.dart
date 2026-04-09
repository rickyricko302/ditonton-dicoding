import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class PopularTVSeriesState extends Equatable {
  const PopularTVSeriesState();

  @override
  List<Object> get props => [];
}

class PopularTVSeriesEmpty extends PopularTVSeriesState {
  const PopularTVSeriesEmpty();
}

class PopularTVSeriesLoading extends PopularTVSeriesState {
  const PopularTVSeriesLoading();
}

class PopularTVSeriesError extends PopularTVSeriesState {
  final String message;

  const PopularTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTVSeriesHasData extends PopularTVSeriesState {
  final List<TVSeries> result;

  const PopularTVSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

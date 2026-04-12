import 'package:core/core.dart';

abstract class AiringTodayTVSeriesState extends Equatable {
  const AiringTodayTVSeriesState();

  @override
  List<Object> get props => [];
}

class AiringTodayTVSeriesEmpty extends AiringTodayTVSeriesState {
  const AiringTodayTVSeriesEmpty();
}

class AiringTodayTVSeriesLoading extends AiringTodayTVSeriesState {
  const AiringTodayTVSeriesLoading();
}

class AiringTodayTVSeriesError extends AiringTodayTVSeriesState {
  final String message;

  const AiringTodayTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class AiringTodayTVSeriesHasData extends AiringTodayTVSeriesState {
  final List<TVSeries> result;

  const AiringTodayTVSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

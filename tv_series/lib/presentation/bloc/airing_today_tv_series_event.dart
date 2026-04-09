import 'package:equatable/equatable.dart';

abstract class AiringTodayTVSeriesEvent extends Equatable {
  const AiringTodayTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringTodayTVSeries extends AiringTodayTVSeriesEvent {}

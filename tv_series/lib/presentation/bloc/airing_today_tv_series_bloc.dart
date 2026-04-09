import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_airing_today_tv_series.dart';
import 'airing_today_tv_series_event.dart';
import 'airing_today_tv_series_state.dart';

class AiringTodayTVSeriesBloc
    extends Bloc<AiringTodayTVSeriesEvent, AiringTodayTVSeriesState> {
  final GetAiringTodayTVSeries _getAiringTodayTVSeries;

  AiringTodayTVSeriesBloc(this._getAiringTodayTVSeries)
      : super(const AiringTodayTVSeriesEmpty()) {
    on<FetchAiringTodayTVSeries>((event, emit) async {
      emit(const AiringTodayTVSeriesLoading());
      final result = await _getAiringTodayTVSeries.execute();

      result.fold(
        (failure) {
          emit(AiringTodayTVSeriesError(failure.message));
        },
        (data) {
          emit(AiringTodayTVSeriesHasData(data));
        },
      );
    });
  }
}

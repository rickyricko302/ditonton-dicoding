import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';
import 'top_rated_tv_series_event.dart';
import 'top_rated_tv_series_state.dart';

class TopRatedTVSeriesBloc
    extends Bloc<TopRatedTVSeriesEvent, TopRatedTVSeriesState> {
  final GetTopRatedTVSeries _getTopRatedTVSeries;

  TopRatedTVSeriesBloc(this._getTopRatedTVSeries)
      : super(const TopRatedTVSeriesEmpty()) {
    on<FetchTopRatedTVSeries>((event, emit) async {
      emit(const TopRatedTVSeriesLoading());
      final result = await _getTopRatedTVSeries.execute();

      result.fold(
        (failure) {
          emit(TopRatedTVSeriesError(failure.message));
        },
        (data) {
          emit(TopRatedTVSeriesHasData(data));
        },
      );
    });
  }
}

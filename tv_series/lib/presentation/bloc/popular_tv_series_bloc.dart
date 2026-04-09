import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_tv_series.dart';
import 'popular_tv_series_event.dart';
import 'popular_tv_series_state.dart';

class PopularTVSeriesBloc
    extends Bloc<PopularTVSeriesEvent, PopularTVSeriesState> {
  final GetPopularTVSeries _getPopularTVSeries;

  PopularTVSeriesBloc(this._getPopularTVSeries)
      : super(const PopularTVSeriesEmpty()) {
    on<FetchPopularTVSeries>((event, emit) async {
      emit(const PopularTVSeriesLoading());
      final result = await _getPopularTVSeries.execute();

      result.fold(
        (failure) {
          emit(PopularTVSeriesError(failure.message));
        },
        (data) {
          emit(PopularTVSeriesHasData(data));
        },
      );
    });
  }
}

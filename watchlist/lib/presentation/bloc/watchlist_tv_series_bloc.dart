import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';
import 'watchlist_tv_series_event.dart';
import 'watchlist_tv_series_state.dart';

class WatchlistTVSeriesBloc
    extends Bloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState> {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  WatchlistTVSeriesBloc(this.getWatchlistTVSeries)
      : super(WatchlistTVSeriesEmpty()) {
    on<FetchWatchlistTVSeries>((event, emit) async {
      emit(WatchlistTVSeriesLoading());
      final result = await getWatchlistTVSeries.execute();

      result.fold(
        (failure) => emit(WatchlistTVSeriesError(failure.message)),
        (tvSeriesData) => emit(WatchlistTVSeriesHasData(tvSeriesData)),
      );
    });
  }
}

import 'package:core/data/services/watchlist_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/get_recommendations_tv_series.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import 'tv_series_detail_event.dart';
import 'tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  final GetTVSeriesDetail getTVSeriesDetail;
  final GetRecommendationsTVSeries getRecommendationsTVSeries;
  final WatchlistService watchlistService;

  TVSeriesDetailBloc({
    required this.getTVSeriesDetail,
    required this.getRecommendationsTVSeries,
    required this.watchlistService,
  }) : super(TVSeriesDetailState.initial()) {
    on<FetchTVSeriesDetail>((event, emit) async {
      emit(state.copyWith(tvSeriesState: RequestState.Loading));
      final detailResult = await getTVSeriesDetail.execute(event.id);
      final recommendationResult =
          await getRecommendationsTVSeries.execute(event.id);

      detailResult.fold(
        (failure) {
          emit(state.copyWith(
            tvSeriesState: RequestState.Error,
            message: failure.message,
          ));
        },
        (tvSeriesDetail) {
          emit(state.copyWith(
            tvSeriesState: RequestState.Loaded,
            tvSeriesDetail: tvSeriesDetail,
            recommendationState: RequestState.Loading,
            message: '',
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message,
              ));
            },
            (recommendations) {
              emit(state.copyWith(
                recommendationState: RequestState.Loaded,
                tvSeriesRecommendations: recommendations,
                message: '',
              ));
            },
          );
        },
      );
    });

    on<AddWatchlistTVSeries>((event, emit) async {
      final result = await watchlistService.addTvSeriesWatchlist(event.tvSeriesDetail);
      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );
      add(LoadWatchlistStatusTVSeries(event.tvSeriesDetail.id));
    });

    on<RemoveFromWatchlistTVSeries>((event, emit) async {
      final result = await watchlistService.removeTvSeriesWatchlist(event.tvSeriesDetail);
      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );
      add(LoadWatchlistStatusTVSeries(event.tvSeriesDetail.id));
    });

    on<LoadWatchlistStatusTVSeries>((event, emit) async {
      final result = await watchlistService.loadTvSeriesWatchlistStatus(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}

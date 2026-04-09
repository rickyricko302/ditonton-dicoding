import 'package:core/core.dart';
import 'package:core/data/services/watchlist_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final WatchlistService watchlistService;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.watchlistService,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.Loading));
      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      await detailResult.fold(
        (failure) async {
          emit(state.copyWith(
            movieDetailState: RequestState.Error,
            message: failure.message,
          ));
        },
        (movie) async {
          emit(state.copyWith(
            recommendationState: RequestState.Loading,
            movieDetail: movie,
            movieDetailState: RequestState.Loaded,
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
                movieRecommendations: recommendations,
                message: '',
              ));
            },
          );
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final result = await watchlistService.addMovieWatchlist(event.movie);
      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );
      add(LoadWatchlistStatus(event.movie.id));
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await watchlistService.removeMovieWatchlist(event.movie);
      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );
      add(LoadWatchlistStatus(event.movie.id));
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await watchlistService.loadWatchlistStatus(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}

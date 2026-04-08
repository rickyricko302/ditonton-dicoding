import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_watchlist_movies.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc(this.getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (moviesData) => emit(WatchlistMovieHasData(moviesData)),
      );
    });
  }
}

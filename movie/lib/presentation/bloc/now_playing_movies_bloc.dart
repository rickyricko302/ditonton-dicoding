import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import 'now_playing_movies_event.dart';
import 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMoviesLoading());
      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) => emit(NowPlayingMoviesError(failure.message)),
        (moviesData) => emit(NowPlayingMoviesHasData(moviesData)),
      );
    });
  }
}

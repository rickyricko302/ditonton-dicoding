import 'package:core/core.dart';

abstract class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingMoviesEvent {}

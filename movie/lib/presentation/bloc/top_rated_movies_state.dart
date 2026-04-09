import 'package:core/core.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesEmpty extends TopRatedMoviesState {
  const TopRatedMoviesEmpty();
}

class TopRatedMoviesLoading extends TopRatedMoviesState {
  const TopRatedMoviesLoading();
}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMoviesHasData extends TopRatedMoviesState {
  final List<Movie> result;

  const TopRatedMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

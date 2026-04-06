part of 'search_bloc.dart';

@immutable
sealed class SearchState extends Equatable {}

final class SearchEmpty extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoading extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
  @override
  List<Object?> get props => [message];
}

final class SearchHasData extends SearchState {
  final List<Movie> movie;
  final List<TVSeries> tvSeries;

  SearchHasData({
    this.movie = const <Movie>[],
    this.tvSeries = const <TVSeries>[],
  });
  @override
  List<Object?> get props => [movie, tvSeries];
}

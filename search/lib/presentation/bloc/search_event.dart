part of 'search_bloc.dart';

@immutable
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class OnQueryMovieChanged extends SearchEvent {
  final String query;
  const OnQueryMovieChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

class OnQueryTVSeriesChanged extends SearchEvent {
  final String query;
  const OnQueryTVSeriesChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

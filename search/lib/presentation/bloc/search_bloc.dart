import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final SearchTVSeries searchTVSeries;
  SearchBloc(this.searchMovies, this.searchTVSeries) : super(SearchEmpty()) {
    on<SearchEvent>((event, emit) {});
    on<OnQueryMovieChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await searchMovies.execute(query);

      result.fold(
        (failure) => emit(SearchError(message: failure.message)),
        (data) => emit(SearchHasData(movie: data, tvSeries: [])),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
    on<OnQueryTVSeriesChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await searchTVSeries.execute(query);

      result.fold(
        (failure) => emit(SearchError(message: failure.message)),
        (data) => emit(SearchHasData(movie: [], tvSeries: data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

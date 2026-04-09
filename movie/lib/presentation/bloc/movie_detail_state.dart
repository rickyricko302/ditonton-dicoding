import 'package:core/core.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final List<Movie> movieRecommendations;
  final RequestState movieDetailState;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieRecommendations,
    required this.movieDetailState,
    required this.recommendationState,
    required this.message,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  factory MovieDetailState.initial() => const MovieDetailState(
    movieDetail: null,
    movieRecommendations: [],
    movieDetailState: RequestState.Empty,
    recommendationState: RequestState.Empty,
    message: '',
    isAddedToWatchlist: false,
    watchlistMessage: '',
  );

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    List<Movie>? movieRecommendations,
    RequestState? movieDetailState,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieDetail,
    movieRecommendations,
    movieDetailState,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

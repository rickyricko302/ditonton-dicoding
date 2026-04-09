import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class TVSeriesDetailState extends Equatable {
  final TVSeriesDetail? tvSeriesDetail;
  final List<TVSeries> tvSeriesRecommendations;
  final RequestState tvSeriesState;
  final RequestState recommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const TVSeriesDetailState({
    required this.tvSeriesDetail,
    required this.tvSeriesRecommendations,
    required this.tvSeriesState,
    required this.recommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  factory TVSeriesDetailState.initial() {
    return const TVSeriesDetailState(
      tvSeriesDetail: null,
      tvSeriesRecommendations: [],
      tvSeriesState: RequestState.Empty,
      recommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

   TVSeriesDetailState copyWith({
    TVSeriesDetail? tvSeriesDetail,
    List<TVSeries>? tvSeriesRecommendations,
    RequestState? tvSeriesState,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TVSeriesDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesRecommendations: tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesDetail,
        tvSeriesRecommendations,
        tvSeriesState,
        recommendationState,
        message,
        watchlistMessage,
        isAddedToWatchlist,
      ];
}

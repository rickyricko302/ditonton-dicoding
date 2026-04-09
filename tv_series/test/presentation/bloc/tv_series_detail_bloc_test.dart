import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/data/services/watchlist_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_detail_state.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetRecommendationsTVSeries,
  WatchlistService,
])
void main() {
  late TVSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetRecommendationsTVSeries mockGetRecommendationsTVSeries;
  late MockWatchlistService mockWatchlistService;

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetRecommendationsTVSeries = MockGetRecommendationsTVSeries();
    mockWatchlistService = MockWatchlistService();
    tvSeriesDetailBloc = TVSeriesDetailBloc(
      getTVSeriesDetail: mockGetTVSeriesDetail,
      getRecommendationsTVSeries: mockGetRecommendationsTVSeries,
      watchlistService: mockWatchlistService,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, TVSeriesDetailState.initial());
  });

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetRecommendationsTVSeries.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesList));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(tvSeriesState: RequestState.Loading),
      TVSeriesDetailState.initial().copyWith(
        tvSeriesState: RequestState.Loaded,
        tvSeriesDetail: testTVSeriesDetail,
        recommendationState: RequestState.Loading,
      ),
      TVSeriesDetailState.initial().copyWith(
        tvSeriesState: RequestState.Loaded,
        tvSeriesDetail: testTVSeriesDetail,
        recommendationState: RequestState.Loaded,
        tvSeriesRecommendations: testTVSeriesList,
      ),
    ],
    verify: (bloc) {
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetRecommendationsTVSeries.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetRecommendationsTVSeries.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesList));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(tvSeriesState: RequestState.Loading),
      TVSeriesDetailState.initial().copyWith(
        tvSeriesState: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetTVSeriesDetail.execute(tId));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'should updated watchlist status when add to watchlist is success',
    build: () {
      when(mockWatchlistService.addTvSeriesWatchlist(testTVSeriesDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockWatchlistService.loadTvSeriesWatchlistStatus(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(AddWatchlistTVSeries(testTVSeriesDetail)),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(watchlistMessage: 'Added to Watchlist'),
      TVSeriesDetailState.initial().copyWith(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      ),
    ],
    verify: (bloc) {
      verify(mockWatchlistService.addTvSeriesWatchlist(testTVSeriesDetail));
    },
  );

  blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
    'should updated watchlist status when remove from watchlist is success',
    build: () {
      when(mockWatchlistService.removeTvSeriesWatchlist(testTVSeriesDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockWatchlistService.loadTvSeriesWatchlistStatus(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      return tvSeriesDetailBloc;
    },
    seed: () => TVSeriesDetailState.initial().copyWith(isAddedToWatchlist: true),
    act: (bloc) => bloc.add(RemoveFromWatchlistTVSeries(testTVSeriesDetail)),
    expect: () => [
      TVSeriesDetailState.initial().copyWith(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: true,
      ),
      TVSeriesDetailState.initial().copyWith(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      ),
    ],
    verify: (bloc) {
      verify(mockWatchlistService.removeTvSeriesWatchlist(testTVSeriesDetail));
    },
  );
}

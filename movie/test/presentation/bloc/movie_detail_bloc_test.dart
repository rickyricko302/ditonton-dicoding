import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/data/services/watchlist_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations, WatchlistService])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockWatchlistService mockWatchlistService;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockWatchlistService = MockWatchlistService();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      watchlistService: mockWatchlistService,
    );
  });

  const tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit isAddedToWatchlist true when status is true',
      build: () {
        when(
          mockWatchlistService.loadWatchlistStatus(tId),
        ).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (bloc) {
        verify(mockWatchlistService.loadWatchlistStatus(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit watchlistMessage when add watchlist success',
      build: () {
        when(
          mockWatchlistService.addMovieWatchlist(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockWatchlistService.loadWatchlistStatus(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (bloc) {
        verify(mockWatchlistService.addMovieWatchlist(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit watchlistMessage when remove watchlist success',
      build: () {
        when(
          mockWatchlistService.removeMovieWatchlist(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockWatchlistService.loadWatchlistStatus(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) {
        verify(mockWatchlistService.removeMovieWatchlist(testMovieDetail));
      },
    );
  });
}

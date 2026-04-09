import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_state.dart';
import 'package:tv_series/tv_series.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVSeries])
void main() {
  late PopularTVSeriesBloc popularTVSeriesBloc;
  late MockGetPopularTVSeries mockGetPopularTVSeries;

  setUp(() {
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    popularTVSeriesBloc = PopularTVSeriesBloc(mockGetPopularTVSeries);
  });

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    originCountry: const ['originCountry'],
    originalLanguage: 'originalLanguage',
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  test('initial state should be empty', () {
    expect(popularTVSeriesBloc.state, const PopularTVSeriesEmpty());
  });

  blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return popularTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTVSeries()),
    expect: () => [
      const PopularTVSeriesLoading(),
      PopularTVSeriesHasData(tTVSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTVSeries.execute());
    },
  );

  blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTVSeries()),
    expect: () => [
      const PopularTVSeriesLoading(),
      const PopularTVSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTVSeries.execute());
    },
  );
}

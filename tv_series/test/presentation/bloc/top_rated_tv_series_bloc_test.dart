import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late TopRatedTVSeriesBloc topRatedTVSeriesBloc;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  setUp(() {
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    topRatedTVSeriesBloc = TopRatedTVSeriesBloc(mockGetTopRatedTVSeries);
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
    expect(topRatedTVSeriesBloc.state, const TopRatedTVSeriesEmpty());
  });

  blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      return topRatedTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
    expect: () => [
      const TopRatedTVSeriesLoading(),
      TopRatedTVSeriesHasData(tTVSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );

  blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
    expect: () => [
      const TopRatedTVSeriesLoading(),
      const TopRatedTVSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTVSeries.execute());
    },
  );
}

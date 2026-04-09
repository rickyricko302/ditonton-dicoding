import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/presentation/bloc/airing_today_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/airing_today_tv_series_event.dart';
import 'package:tv_series/presentation/bloc/airing_today_tv_series_state.dart';
import 'package:tv_series/tv_series.dart';

import 'airing_today_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTVSeries])
void main() {
  late AiringTodayTVSeriesBloc airingTodayTVSeriesBloc;
  late MockGetAiringTodayTVSeries mockGetAiringTodayTVSeries;

  setUp(() {
    mockGetAiringTodayTVSeries = MockGetAiringTodayTVSeries();
    airingTodayTVSeriesBloc = AiringTodayTVSeriesBloc(mockGetAiringTodayTVSeries);
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
    expect(airingTodayTVSeriesBloc.state, const AiringTodayTVSeriesEmpty());
  });

  blocTest<AiringTodayTVSeriesBloc, AiringTodayTVSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      return airingTodayTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVSeries()),
    expect: () => [
      const AiringTodayTVSeriesLoading(),
      AiringTodayTVSeriesHasData(tTVSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );

  blocTest<AiringTodayTVSeriesBloc, AiringTodayTVSeriesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetAiringTodayTVSeries.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return airingTodayTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVSeries()),
    expect: () => [
      const AiringTodayTVSeriesLoading(),
      const AiringTodayTVSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTVSeries.execute());
    },
  );
}

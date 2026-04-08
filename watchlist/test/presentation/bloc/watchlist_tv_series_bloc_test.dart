import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv_series.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_series_event.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_series_state.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late WatchlistTVSeriesBloc watchlistTVSeriesBloc;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;

  setUp(() {
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    watchlistTVSeriesBloc = WatchlistTVSeriesBloc(mockGetWatchlistTVSeries);
  });

  test('initial state should be empty', () {
    expect(watchlistTVSeriesBloc.state, WatchlistTVSeriesEmpty());
  });

  blocTest<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistTVSeries]));
      return watchlistTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    expect: () => [
      WatchlistTVSeriesLoading(),
      WatchlistTVSeriesHasData([testWatchlistTVSeries]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );

  blocTest<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
    'should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      return watchlistTVSeriesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    expect: () => [
      WatchlistTVSeriesLoading(),
      WatchlistTVSeriesError("Can't get data"),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTVSeries.execute());
    },
  );
}

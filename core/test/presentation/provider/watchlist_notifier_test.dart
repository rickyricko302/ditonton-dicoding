import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTVSeries])
void main() {
  late WatchlistNotifier provider;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    provider =
        WatchlistNotifier(
          getWatchlistMovies: mockGetWatchlistMovies,
          getWatchlistTVSeries: mockGetWatchlistTVSeries,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(
      mockGetWatchlistMovies.execute(),
    ).thenAnswer((_) async => Right([testWatchlistMovie]));
    // act
    await provider.fetchWatchlistMovies();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistMovies, [testWatchlistMovie]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(
      mockGetWatchlistMovies.execute(),
    ).thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistMovies();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}

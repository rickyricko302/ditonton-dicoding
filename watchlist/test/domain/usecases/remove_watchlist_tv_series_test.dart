import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = RemoveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should remove tv series from watchlist', () async {
    // arrange
    when(
      mockTVSeriesRepository.removeWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockTVSeriesRepository.removeWatchlist(testTVSeriesDetail));
    expect(result, const Right('Removed from Watchlist'));
  });
}

import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SaveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should save tv series to watchlist', () async {
    // arrange
    when(
      mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}

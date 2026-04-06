import 'package:core/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatusTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetWatchlistStatusTVSeries(mockTVSeriesRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(
      mockTVSeriesRepository.isAddedToWatchlist(1),
    ).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}

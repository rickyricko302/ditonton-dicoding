import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/get_airing_today_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetAiringTodayTVSeries(mockTVSeriesRepository);
  });

  final List<TVSeries> tTVSeriesList = [];

  test('should get airing today tv series from repository', () async {
    // arrange
    when(
      mockTVSeriesRepository.getAiringTodayTVSeries(),
    ).thenAnswer((_) async => Right(tTVSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVSeriesList));
  });
}

import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetPopularTVSeries(mockTVSeriesRepository);
  });

  final List<TVSeries> tTVSeriesList = [];

  test('should get popular tv series from the repository', () async {
    // arrange
    when(
      mockTVSeriesRepository.getPopularTVSeries(),
    ).thenAnswer((_) async => Right(tTVSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVSeriesList));
  });
}

import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/get_recommendations_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetRecommendationsTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetRecommendationsTVSeries(mockTVSeriesRepository);
  });

  final List<TVSeries> tTVSeriesList = [];
  final tId = 1;

  test(
    'should get list of tv series recommendations from the repository',
    () async {
      // arrange
      when(
        mockTVSeriesRepository.getTVSeriesRecommendations(tId),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTVSeriesList));
    },
  );
}

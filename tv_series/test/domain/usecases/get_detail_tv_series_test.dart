import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late GetTVSeriesDetail usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesDetail(mockTVSeriesRepository);
  });

  group('Get TV Series Detail', () {
    test(
      'should return tv series detail when success call remote data',
      () async {
        // arrange
        when(
          mockTVSeriesRepository.getTVSeriesDetail(1),
        ).thenAnswer((_) async => Right(testTVSeriesDetail));
        // act
        final result = await usecase.execute(1);
        // assert
        verify(mockTVSeriesRepository.getTVSeriesDetail(1));
        final resultDetail = result.getOrElse(() => throw Exception());
        expect(resultDetail, testTVSeriesDetail);
      },
    );
  });
}

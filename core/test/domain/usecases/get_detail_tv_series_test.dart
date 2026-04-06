import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:core/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late GetTVSeriesDetail usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesDetail(mockTVSeriesRepository);
  });

  group('Get TV Series Detail', () {
    final tTVSeriesDetailModel = TVSeriesDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );
    final tTVSeriesDetail = tTVSeriesDetailModel.toEntity();

    test(
      'should return tv series detail when success call remote data',
      () async {
        // arrange
        when(
          mockTVSeriesRepository.getTVSeriesDetail(1),
        ).thenAnswer((_) async => Right(tTVSeriesDetail));
        // act
        final result = await usecase.execute(1);
        // assert
        verify(mockTVSeriesRepository.getTVSeriesDetail(1));
        final resultDetail = result.getOrElse(() => throw Exception());
        expect(resultDetail, tTVSeriesDetail);
      },
    );
  });
}

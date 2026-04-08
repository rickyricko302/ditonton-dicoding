import 'package:core/core.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([TVSeriesDetailNotifier])
void main() {
  late MockTVSeriesDetailNotifier mockTVSeriesDetailNotifier;
  setUp(() {
    mockTVSeriesDetailNotifier = MockTVSeriesDetailNotifier();
  });

  group('TV Series Detail Notifier', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockTVSeriesDetailNotifier.state).thenReturn(RequestState.Loading);
      // act
      final result = mockTVSeriesDetailNotifier.state;
      // assert
      expect(result, RequestState.Loading);
    });
    test(
      'should change state to loaded when data is gotten successfully',
      () async {
        // arrange
        when(mockTVSeriesDetailNotifier.state).thenReturn(RequestState.Loaded);
        // act
        final result = mockTVSeriesDetailNotifier.state;
        // assert
        expect(result, RequestState.Loaded);
      },
    );
    test(
      'should change state to error when data is gotten unsuccessfully',
      () async {
        // arrange
        when(mockTVSeriesDetailNotifier.state).thenReturn(RequestState.Error);
        // act
        final result = mockTVSeriesDetailNotifier.state;
        // assert
        expect(result, RequestState.Error);
      },
    );
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockTVSeriesDetailNotifier.state).thenReturn(RequestState.Error);
      when(mockTVSeriesDetailNotifier.message).thenReturn('Server Failure');
      // act
      final stateResult = mockTVSeriesDetailNotifier.state;
      final messageResult = mockTVSeriesDetailNotifier.message;
      // assert
      expect(stateResult, RequestState.Error);
      expect(messageResult, 'Server Failure');
    });
  });

  group('List Recommendation', () {
    // list recommendations tv series
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(
        mockTVSeriesDetailNotifier.recommendationsState,
      ).thenReturn(RequestState.Loading);
      // act
      final result = mockTVSeriesDetailNotifier.recommendationsState;
      // assert
      expect(result, RequestState.Loading);
    });
    test(
      'should change state to loaded when data is gotten successfully',
      () async {
        // arrange
        when(
          mockTVSeriesDetailNotifier.recommendationsState,
        ).thenReturn(RequestState.Loaded);
        // act
        final result = mockTVSeriesDetailNotifier.recommendationsState;
        // assert
        expect(result, RequestState.Loaded);
      },
    );
    test(
      'should change state to error when data is gotten unsuccessfully',
      () async {
        // arrange
        when(
          mockTVSeriesDetailNotifier.recommendationsState,
        ).thenReturn(RequestState.Error);
        // act
        final result = mockTVSeriesDetailNotifier.recommendationsState;
        // assert
        expect(result, RequestState.Error);
      },
    );
  });
}

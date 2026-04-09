import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockTVSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

void main() {
  late MockTVSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTVSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display CircularProgressIndicator when loading',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loading,
        ),
      );

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: false,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: true,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: false,
        ),
      );

      final expectedStates = [
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ];

      whenListen(mockBloc, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: false,
        ),
      );

      final expectedStates = [
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeriesDetail: testTVSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: <TVSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ];

      whenListen(mockBloc, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

import 'package:core/core.dart';

import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TVSeriesDetailNotifier])
void main() {
  late MockTVSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVSeriesDetailNotifier();
    // Default mocks to avoid MissingStubError
    when(mockNotifier.fetchTVSeriesDetail(any)).thenAnswer((_) async {});
    when(
      mockNotifier.fetchTVSeriesRecommendations(any),
    ).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(any)).thenAnswer((_) async {});
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display CircularProgressIndicator when loading',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.Loading);

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));

      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display add icon when tv series not added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesDetail).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.recommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesDetail).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.recommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesDetail).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.recommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.Loaded);
      when(mockNotifier.tvSeriesDetail).thenReturn(testTVSeriesDetail);
      when(mockNotifier.recommendationsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.recommendations).thenReturn(<TVSeries>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}

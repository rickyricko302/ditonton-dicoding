import 'package:core/core.dart';

import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([PopularTVSeriesNotifier])
void main() {
  late MockPopularTVSeriesNotifier mockPopularTVSeriesNotifier;

  setUp(() {
    mockPopularTVSeriesNotifier = MockPopularTVSeriesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTVSeriesNotifier>.value(
      value: mockPopularTVSeriesNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display CircularProgressIndicator when data is loading', (
    WidgetTester tester,
  ) async {
    when(mockPopularTVSeriesNotifier.state).thenReturn(RequestState.Loading);
    final circularProgressIndicatorFinder = find.byType(
      CircularProgressIndicator,
    );
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(PopularTVSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockPopularTVSeriesNotifier.state).thenReturn(RequestState.Loaded);
    when(mockPopularTVSeriesNotifier.popularTVSeries).thenReturn(<TVSeries>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

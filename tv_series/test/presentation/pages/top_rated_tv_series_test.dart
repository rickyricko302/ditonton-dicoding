import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import 'top_rated_tv_series_test.mocks.dart';

@GenerateMocks([TopRatedTVSeriesNotifier])
void main() {
  late MockTopRatedTVSeriesNotifier mockTopRatedTVSeriesNotifier;

  setUp(() {
    mockTopRatedTVSeriesNotifier = MockTopRatedTVSeriesNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTVSeriesNotifier>.value(
      value: mockTopRatedTVSeriesNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display CircularProgressIndicator when data is loading', (
    WidgetTester tester,
  ) async {
    when(mockTopRatedTVSeriesNotifier.state).thenReturn(RequestState.Loading);
    final circularProgressIndicatorFinder = find.byType(
      CircularProgressIndicator,
    );
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should display listview data tv series when succesfully load', (
    WidgetTester tester,
  ) async {
    when(mockTopRatedTVSeriesNotifier.state).thenReturn(RequestState.Loaded);
    when(
      mockTopRatedTVSeriesNotifier.topRatedTVSeries,
    ).thenReturn(<TVSeries>[]);
    final listViewFinder = find.byType(ListView);
    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));
    expect(listViewFinder, findsOneWidget);
  });
}

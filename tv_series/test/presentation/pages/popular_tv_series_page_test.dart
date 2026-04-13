import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([PopularTVSeriesBloc])
void main() {
  late MockPopularTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display CircularProgressIndicator when data is loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const PopularTVSeriesLoading());
    when(
      mockBloc.stream,
    ).thenAnswer((_) => Stream.value(const PopularTVSeriesLoading()));

    final circularProgressIndicatorFinder = find.byType(
      CircularProgressIndicator,
    );
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const PopularTVSeriesHasData(<TVSeries>[]));
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.value(const PopularTVSeriesHasData(<TVSeries>[])),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

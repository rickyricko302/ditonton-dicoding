import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'top_rated_tv_series_test.mocks.dart';

@GenerateMocks([TopRatedTVSeriesBloc])
void main() {
  late MockTopRatedTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display CircularProgressIndicator when data is loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const TopRatedTVSeriesLoading());
    when(
      mockBloc.stream,
    ).thenAnswer((_) => Stream.value(const TopRatedTVSeriesLoading()));

    final circularProgressIndicatorFinder = find.byType(
      CircularProgressIndicator,
    );
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));
    expect(centerFinder, findsOneWidget);
    expect(circularProgressIndicatorFinder, findsOneWidget);
  });

  testWidgets('should display listview data tv series when succesfully load', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const TopRatedTVSeriesHasData(<TVSeries>[]));
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.value(const TopRatedTVSeriesHasData(<TVSeries>[])),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

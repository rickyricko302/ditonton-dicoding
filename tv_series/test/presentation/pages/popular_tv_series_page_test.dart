import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/tv_series.dart';

class MockPopularTVSeriesBloc
    extends MockBloc<PopularTVSeriesEvent, PopularTVSeriesState>
    implements PopularTVSeriesBloc {}

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
    when(() => mockBloc.state).thenReturn(const PopularTVSeriesLoading());

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
    when(
      () => mockBloc.state,
    ).thenReturn(const PopularTVSeriesHasData(<TVSeries>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });
}

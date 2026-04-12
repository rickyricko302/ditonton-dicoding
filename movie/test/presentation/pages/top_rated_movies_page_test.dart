import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/top_rated_movies_event.dart';
import 'package:movie/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const TopRatedMoviesLoading());
    when(mockBloc.stream).thenAnswer((_) => Stream.value(const TopRatedMoviesLoading()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const TopRatedMoviesHasData(<Movie>[]));
    when(mockBloc.stream).thenAnswer((_) => Stream.value(const TopRatedMoviesHasData(<Movie>[])));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const TopRatedMoviesError('Error message'));
    when(mockBloc.stream).thenAnswer((_) => Stream.value(const TopRatedMoviesError('Error message')));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

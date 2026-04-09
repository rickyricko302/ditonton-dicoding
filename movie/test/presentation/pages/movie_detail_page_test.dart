import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: true,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );

      // We need to trigger the listener, so we need a state change
      final expectedStates = [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ];

      whenListen(mockBloc, Stream.fromIterable(expectedStates));

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

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
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
        ),
      );

      final expectedStates = [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Database Failure',
        ),
      ];

      whenListen(mockBloc, Stream.fromIterable(expectedStates));
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump(); // trigger event
      await tester.pump(const Duration(seconds: 1)); // ⬅️ cukup untuk dialog

      expect(find.byType(AlertDialog), findsOneWidget);
    },
  );
}

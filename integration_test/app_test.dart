import 'package:ditonton/main.dart' as app;
import 'package:tv_series/tv_series.dart';
import 'package:movie/movie.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final di = GetIt.instance;
    await di.reset();
  });

  group('Movie Integration Test', () {
    testWidgets('should show movie content on home page', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('should navigate to popular movies page', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final popularSubHeading = find.text('See More').at(0);
      await tester.tap(popularSubHeading);
      await tester.pumpAndSettle();

      expect(find.byType(PopularMoviesPage), findsOneWidget);
    });

    testWidgets('should navigate to top rated movies page', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final topRatedSubHeading = find.text('See More').at(1);
      await tester.tap(topRatedSubHeading);
      await tester.pumpAndSettle();

      expect(find.byType(TopRatedMoviesPage), findsOneWidget);
    });
  });

  group('TV Series Integration Test', () {
    testWidgets('should navigate to TV Series page and show its content', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Ditonton'), findsOneWidget);

      final tvSeriesButton = find.text('TV Series');
      expect(tvSeriesButton, findsOneWidget);

      await tester.tap(tvSeriesButton);

      await tester.pumpAndSettle();

      expect(find.byType(TVSeriesPage), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);

      final backButton = find.byType(BackButton);
      await tester.tap(backButton.first);
      await tester.pumpAndSettle();

      expect(find.text('Ditonton'), findsOneWidget);
    });

    testWidgets(
      'should navigate to detail TV Series page when click TVCardList',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        final tvSeriesButton = find.text('TV Series');
        expect(tvSeriesButton, findsOneWidget);
        await tester.tap(tvSeriesButton);
        await tester.pumpAndSettle();

        expect(find.byType(TVSeriesPage), findsOneWidget);
        final tvCard = find.byKey(const Key('airing_today_0'));
        expect(tvCard, findsOneWidget);
        await tester.tap(tvCard);
        await tester.pumpAndSettle();
        expect(find.byType(TVSeriesDetailPage), findsOneWidget);
      },
    );
  });

  group('Search Integration Test', () {
    testWidgets('should navigate to search page and perform search', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'spiderman');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      // kalau ada debounce
      await tester.pump(const Duration(milliseconds: 600));

      // tunggu API
      await tester.pumpAndSettle();

      expect(find.text('Search Result'), findsOneWidget);
      expect(find.byKey(const Key('search_movie_list')), findsOneWidget);
    });
  });

  group('Watchlist Integration Test', () {
    testWidgets('should open Watchlist page from drawer', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      final scaffold = tester.firstState<ScaffoldState>(find.byType(Scaffold));
      scaffold.openDrawer();
      await tester.pumpAndSettle();

      final watchlistMenu = find.text('Watchlist');
      await tester.tap(watchlistMenu);
      await tester.pumpAndSettle();

      expect(find.byType(WatchlistPage), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);
    });
  });
}

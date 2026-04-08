import 'package:ditonton/main.dart' as app;
import 'package:tv_series/tv_series.dart';
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
}

import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTVSeriesTable = testTVSeriesTable;

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTVSeriesTable.toJson();
    // assert
    final expectedJsonMap = {
      'id': 1,
      'title': 'name',
      'posterPath': 'posterPath',
      'overview': 'overview',
      'category': 'tv series',
    };
    expect(result, expectedJsonMap);
  });

  test('should be a subclass of TVSeries entity', () async {
    final result = tTVSeriesTable.toEntity();
    expect(result, testWatchlistTVSeries);
  });
}

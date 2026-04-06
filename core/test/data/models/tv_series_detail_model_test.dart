import 'dart:convert';

import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_detail.json'),
      );
      // act
      final result = TVSeriesDetailModel.fromJson(jsonMap);
      // assert
      expect(result.id, 1399);
      expect(result.name, "Game of Thrones");
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_detail.json'),
      );
      final model = TVSeriesDetailModel.fromJson(jsonMap);

      // act
      final result = model.toJson();

      // assert
      expect(result["id"], 1399);
      expect(result["name"], "Game of Thrones");
    });
  });
}

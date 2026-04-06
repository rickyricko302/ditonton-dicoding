import 'dart:convert';
import 'package:core/core.dart';

import '../models/tv_series_detail_model.dart';
import '../models/tv_series_model.dart';
import 'package:http/http.dart' as http;

import '../models/tv_series_response.dart';

abstract class TVSeriesRemoteDataSource {
  Future<List<TVSeriesModel>> getAiringTodayTVSeries();
  Future<List<TVSeriesModel>> getPopularTVSeries();
  Future<List<TVSeriesModel>> getTopRatedTVSeries();
  Future<TVSeriesDetailModel> getTVSeriesDetail(int id);
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id);
  Future<List<TVSeriesModel>> searchTVSeries(String query);
}

class TVSeriesRemoteDataSourceImpl implements TVSeriesRemoteDataSource {
  final http.Client client;

  TVSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVSeriesModel>> getAiringTodayTVSeries() async {
    final response = await client.get(
      Uri.parse('${ApiConfig.BASE_URL}/tv/airing_today?${ApiConfig.API_KEY}'),
    );
    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getPopularTVSeries() async {
    final response = await client.get(
      Uri.parse('${ApiConfig.BASE_URL}/tv/popular?${ApiConfig.API_KEY}'),
    );
    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getTopRatedTVSeries() async {
    final response = await client.get(
      Uri.parse('${ApiConfig.BASE_URL}/tv/top_rated?${ApiConfig.API_KEY}'),
    );
    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVSeriesDetailModel> getTVSeriesDetail(int id) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.BASE_URL}/tv/$id?${ApiConfig.API_KEY}'),
    );
    if (response.statusCode == 200) {
      return TVSeriesDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConfig.BASE_URL}/tv/$id/recommendations?${ApiConfig.API_KEY}',
      ),
    );
    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> searchTVSeries(String query) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConfig.BASE_URL}/search/tv?${ApiConfig.API_KEY}&query=$query',
      ),
    );
    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}

import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:BB_CodingChallenge/model/SearchResult.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _apiClient = ApiClient._internal();
  String _apiKey;

  Future<List<Movie>> fetchMovieList(
      {int page = 0, String searchString}) async {
    try {
      Response response = await Dio().get(
          "https://www.omdbapi.com/?s=$searchString&page=$page&apikey=$_apiKey");

      if (response.statusCode == 200) {
        return SearchResult.fromJson(response.data).search;
      } else {
        throw Exception(
            'Loading data failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  factory ApiClient.initialize() {
    return _apiClient;
  }

  ApiClient._internal() {
    this._apiKey = DotEnv().env['OMDB_API_KEY'];
  }
}

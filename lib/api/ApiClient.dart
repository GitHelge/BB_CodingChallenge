import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:BB_CodingChallenge/model/MovieDetails.dart';
import 'package:BB_CodingChallenge/model/SearchResult.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _apiClient = ApiClient._internal();
  String _apiKey;
  String _domain = "https://www.omdbapi.com/";

  Future<MovieDetails> fetchMovieDetails(String imdbID) async {
    try {
      Response response = await Dio().get("$_domain?i=$imdbID&apikey=$_apiKey");

      if (response.statusCode == 200) {
        return MovieDetails.fromJson(response.data);
      } else {
        throw Exception(
            'Loading movie details failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Movie>> fetchMovieList(
      {int page = 0, String searchString}) async {
    try {
      Response response = await Dio()
          .get("$_domain?s=$searchString&page=$page&apikey=$_apiKey");

      if (response.statusCode == 200) {
        return SearchResult.fromJson(response.data).search;
      } else {
        throw Exception(
            'Loading movie list data failed with status code ${response.statusCode}');
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

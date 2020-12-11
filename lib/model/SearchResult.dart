import 'package:BB_CodingChallenge/model/Movie.dart';


class SearchResult {
  final List<Movie> search;
  final String totalResults;
  final String response;

  SearchResult({ 
    this.search, this.totalResults, this.response
  });

  factory SearchResult.fromJson(Map<String, dynamic> parsedJson) {
    return SearchResult(
      search: parsedJson['Search'].map<Movie>((item) => Movie.fromJson(item)).toList(),
      totalResults: parsedJson['totalResults'],
      response: parsedJson['Response']
    );
  }
}
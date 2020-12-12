import 'package:BB_CodingChallenge/model/Movie.dart';

class MovieDetails {
  final Movie movie;
  final String plot;
  final String actors;
  final String genre;
  final String runtime;

  MovieDetails({this.movie, this.plot, this.actors, this.genre, this.runtime});

  factory MovieDetails.fromJson(Map<String, dynamic> parsedJson) {
    return MovieDetails(
      movie: Movie.fromJson(parsedJson),
      plot: parsedJson['Plot'],
      actors: parsedJson['Actors'],
      genre: parsedJson['Genre'],
      runtime: parsedJson['Runtime'],
    );
  }
}

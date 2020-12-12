/* {
  "Title":"The Lord of the Rings: The Fellowship of the Ring",
  "Year":"2001",
  "Rated":"PG-13",
  "Released":"19 Dec 2001",
  "Runtime":"178 min",
  "Genre":"Action, Adventure, Drama, Fantasy",
  "Director":"Peter Jackson",
  "Writer":"J.R.R. Tolkien (novel), Fran Walsh (screenplay), Philippa Boyens (screenplay), Peter Jackson (screenplay)",
  "Actors":"Alan Howard, Noel Appleby, Sean Astin, Sala Baker",
  "Plot":"A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.",
  "Language":"English, Sindarin",
  "Country":"New Zealand, USA","Awards":"Won 4 Oscars. Another 114 wins & 125 nominations.",
  "Poster":"https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"8.8/10"},{"Source":"Rotten Tomatoes","Value":"91%"},{"Source":"Metacritic","Value":"92/100"}],"Metascore":"92","imdbRating":"8.8","imdbVotes":"1,642,488","imdbID":"tt0120737","Type":"movie","DVD":"N/A","BoxOffice":"N/A","Production":"New Line Cinema, Saul Zaentz Company, WingNut Films","Website":"N/A","Response":"True"}
 */

import 'package:BB_CodingChallenge/model/Movie.dart';

class MovieDetails {
  final Movie movie;
  final String plot;
  final String actors;
  final String genre;
  final String runtime;

  MovieDetails({this.movie, this.plot, this.actors, this.genre, this.runtime});

  factory MovieDetails.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson);
    return MovieDetails(
        movie: Movie.fromJson(parsedJson),
        plot: parsedJson['Plot'],
        actors: parsedJson['Actors'],
        genre: parsedJson['Genre'],
        runtime: parsedJson['Runtime']);
  }
}

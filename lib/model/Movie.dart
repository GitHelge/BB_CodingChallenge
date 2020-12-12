class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String posterUri;

  Movie({this.title, this.year, this.imdbID, this.type, this.posterUri});

  factory Movie.fromJson(Map<String, dynamic> parsedJson) {
    return Movie(
      title: parsedJson['Title'],
      year: parsedJson['Year'],
      imdbID: parsedJson['imdbID'],
      type: parsedJson['Type'],
      posterUri: parsedJson['Poster'],
    );
  }
}

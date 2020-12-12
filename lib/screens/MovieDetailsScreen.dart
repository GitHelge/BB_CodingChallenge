import 'package:BB_CodingChallenge/api/ApiClient.dart';
import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:BB_CodingChallenge/model/MovieDetails.dart';
import 'package:BB_CodingChallenge/widgets/MovieDetailsImage.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  MovieDetailsScreen({Key key, this.movie}) : super(key: key);

  final Movie movie;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<MovieDetailsScreen> {
  final _apiClient = ApiClient.initialize();
  Future<MovieDetails> _movieDetails;

  void _loadMovieDetails(String imdbID) async {
    _movieDetails = _apiClient.fetchMovieDetails(imdbID);
  }

  @override
  void initState() {
    super.initState();
    _loadMovieDetails(widget.movie.imdbID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        ),
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Hero(
                  tag: "poster${widget.movie.imdbID}",
                  child: MovieDetailsImage(movie: widget.movie),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: FutureBuilder(
                    future: _movieDetails,
                    builder: (context, AsyncSnapshot<MovieDetails> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                snapshot.data.movie.title,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  snapshot.data.runtime,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  snapshot.data.plot,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Something went wrong!'),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

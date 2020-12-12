import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieListItem extends StatelessWidget {
  MovieListItem({Key key, @required this.movie, @required this.onTap})
      : super(key: key);

  final Movie movie;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Hero(
                    tag: "poster${movie.imdbID}",
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: movie.posterUri,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        movie.year,
                        style: TextStyle(
                          color: Color.fromRGBO(150, 150, 150, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

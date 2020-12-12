import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieDetailsImage extends StatelessWidget {
  const MovieDetailsImage({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      placeholder: (context, url) => CircularProgressIndicator(),
      imageUrl: movie.posterUri,
    );
  }
}

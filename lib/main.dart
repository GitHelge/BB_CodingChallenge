import 'package:BB_CodingChallenge/api/ApiClient.dart';
import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff332f2b),
        accentColor: Color(0xFFC6562C),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Online Movie Database'),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Movie movie;
  DetailScreen({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(movie.title),
        ),
        body: Container(
          decoration:
              BoxDecoration(color: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE)),
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 300,
                    child: Hero(
                      tag: "poster${movie.imdbID}",
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        imageUrl: movie.posterUri,
                      ),
                    )),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(movie.type)),
                ),
              ],
            ),
          ),
        ));
  }
}

class MovieListItem extends StatelessWidget {
  MovieListItem({Key key, this.movie}) : super(key: key);

  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: DetailScreen(movie: movie),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    placeholder: (context, url) => CircularProgressIndicator(),
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
                  Text(
                    movie.title,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      movie.year,
                      style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scrollController = ScrollController();

  final apiClient = ApiClient.initialize();
  bool isLoading = false;
  int page = 1;
  List<Movie> movieList = [];

  void loadMovies({bool loadNextPage = false}) async {
    print("$loadNextPage, $page");
    setState(() {
      isLoading = true;
      if (loadNextPage) page++;
    });
    final fetchedMovieList =
        await apiClient.fetchMovieList(searchString: "batman", page: page);
    setState(() {
      movieList = [...movieList, ...fetchedMovieList];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMovies();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        if (isLoading) return;
        loadMovies(loadNextPage: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          decoration:
              BoxDecoration(color: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE)),
          child: ListView.builder(
              controller: _scrollController,
              itemCount: movieList.length,
              itemBuilder: (context, index) {
                return MovieListItem(movie: movieList[index]);
              }),
        ));
  }
}

import 'package:BB_CodingChallenge/api/ApiClient.dart';
import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _controller = ScrollController(); 

  final apiClient = ApiClient.initialize();
  bool isLoading = false;
  int page = 1; 
  List<Movie> movieList = [];

  void loadMovies({ bool loadNextPage = false }) async {
    print("$loadNextPage, $page");
    setState(() {
      isLoading = true;
      if (loadNextPage) page++;
    });
    final fetchedMovieList = await apiClient.fetchMovieList(
      searchString: "batman",
      page: page
    );
    print(fetchedMovieList.map((item) => item.title));
    setState(() {
      movieList = [...movieList, ...fetchedMovieList];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMovies();

    _controller.addListener(() {
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
          if (isLoading) return;
          loadMovies(loadNextPage: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: movieList.length, 
        itemBuilder: (context, index) { 
          final item = movieList[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.year),
            leading: CachedNetworkImage(
              errorWidget: (context, url, error) => Icon(Icons.error),
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: item.posterUri,
            ),
          );
        })
    );
  }
}

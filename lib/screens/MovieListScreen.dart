import 'package:BB_CodingChallenge/api/ApiClient.dart';
import 'package:BB_CodingChallenge/model/Movie.dart';
import 'package:BB_CodingChallenge/screens/MovieDetailsScreen.dart';
import 'package:BB_CodingChallenge/widgets/MovieListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:page_transition/page_transition.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  ScrollController _scrollController;
  ApiClient _apiClient;
  bool _loading = false;
  int _page = 1;
  String _searchString;
  String _oldSearchString;
  List<Movie> _movieList;
  SearchBar _searchBar;

  _MovieListScreenState() {
    _apiClient = ApiClient.initialize();
    _scrollController = ScrollController();
    _movieList = [];
    _searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar);
  }

  void onSubmitted(String value) {
    setState(() {
      _oldSearchString = _searchString;
      _searchString = value;
      _page = 1;
    });
    loadMovies();
  }

  void loadMovies({bool loadNextPage = false}) async {
    setState(() {
      _loading = true;
      if (loadNextPage) _page++;
    });
    final movieList = await _apiClient.fetchMovieList(
        searchString: _searchString, page: _page);
    setState(() {
      _movieList = _oldSearchString == _searchString
          ? [..._movieList, ...movieList]
          : movieList;
      _loading = false;
      _oldSearchString = _searchString;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMovies();

    _scrollController.addListener(() {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;
      final double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        if (_loading) return;
        loadMovies(loadNextPage: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Function _handleOnListItemTap(Movie movie) {
    return () => Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: MovieDetailsScreen(movie: movie),
          ),
        );
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(widget.title),
        actions: [_searchBar.getSearchAction(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        ),
        child: _movieList.length > 0
            ? Scrollbar(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _movieList.length,
                  itemBuilder: (context, index) {
                    return MovieListItem(
                      key: Key(_movieList[index].imdbID),
                      movie: _movieList[index],
                      onTap: _handleOnListItemTap(_movieList[index]),
                    );
                  },
                ),
              )
            : Center(
                child: Text("No search results found"),
              ),
      ),
    );
  }
}

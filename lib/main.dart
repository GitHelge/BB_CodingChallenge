import 'package:BB_CodingChallenge/api/ApiClient.dart';
import 'package:BB_CodingChallenge/model/SearchResult.dart';
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

  final apiClient = ApiClient.initialize();
  Future<SearchResult> searchResult;
  @override
  void initState() {
    super.initState();
    searchResult = apiClient.fetchSearchResult(
      searchString: "batman"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: searchResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.search.length, 
              itemBuilder: (context, index) { 
                final item = snapshot.data.search[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.year),
                  leading: CachedNetworkImage(
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: item.posterUri,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 24,
              width: 24,
            ),
          );
        }),
    );
  }
}

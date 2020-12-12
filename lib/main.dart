import 'package:BB_CodingChallenge/screens/MovieListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(OmdbApp());
}

class OmdbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omdb',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[600], // Color(0xff332f2b),
        accentColor: Colors.orange[800], // Color(0xFFC6562C),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieListScreen(title: 'Online Movie Database'),
    );
  }
}

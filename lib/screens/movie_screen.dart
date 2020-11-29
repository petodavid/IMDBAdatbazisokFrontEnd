import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/new_movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/widgets/circular_clipper.dart';
import 'package:flutter_netflix_ui_redesign/widgets/content_scroll.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:html' as html;

class MovieScreen extends StatefulWidget {
  final Movie movie;

  MovieScreen({this.movie});

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  Future<void> _showDialog(Movie movie) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // u// ser must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Biztos szeretnéd törölni a következő filmet?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(movie.nev),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Törlés'),
              onPressed: () {
                deleteMovie(movie);
                Future.delayed(Duration(milliseconds: 500), () {
                  Navigator.of(context).pop();
                  html.window.location.reload();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: Hero(
                  tag: widget.movie.filmId,
                  child: ClipShadowPath(
                    clipper: CircularClipper(),
                    shadow: Shadow(blurRadius: 20.0),
                    child: Image(
                      height: 400.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.movie.filmKepek.first.kepUrl),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(left: 30.0),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30.0,
                    color: Colors.white,
                  ),
                ],
              ),
              Positioned.fill(
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(10.0),
                    elevation: 12.0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => NewMovieScreen(
                            movie: widget.movie,
                          ),
                        ),
                      );
                    },
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Icon(
                        FontAwesomeIcons.userEdit,
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.movie.nev.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.movie.kategoria,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  '${widget.movie.ertekeles}/10',
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Színész',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          widget.movie.szinesz.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 120.0,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.movie.leiras,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ContentScroll(
            images: widget.movie.filmKepek.map((e) => e.kepUrl).toList(),
            title: 'Screenshots',
            imageHeight: 200.0,
            imageWidth: 250.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 200),
            child: SizedBox(
              child: FlatButton(
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: () => _showDialog(widget.movie),
                child: Text(
                  'Törlés',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

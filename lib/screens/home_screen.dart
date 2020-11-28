import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/genres_model.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:flutter_netflix_ui_redesign/screens/movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/screens/new_movie_screen.dart';
import 'package:flutter_netflix_ui_redesign/widgets/content_scroll.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  _movieSelector(int index, List<Movie> movies) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 270.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => MovieScreen(movie: movies[index]),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Hero(
                    tag: movies[index].filmId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image:
                            NetworkImage(movies[index].filmKepek.first.kepUrl),
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 30.0,
              bottom: 40.0,
              child: Container(
                width: 250.0,
                child: Text(
                  movies[index].nev.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => NewMovieScreen(),
          ),
        ),
      ),
      backgroundColor: Colors.white10,
      body: FutureBuilder(
        future: getMovies(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Movie>> movieSnapshot) {
          if (movieSnapshot.hasData) {
            final movies = movieSnapshot.data;
            return ListView(
              children: <Widget>[
                Container(
                  height: 280.0,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _movieSelector(index, movies);
                    },
                  ),
                ),
                FutureBuilder(
                  future: getGenres(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Genre>> genreSnapshot) {
                    if (genreSnapshot.hasData) {
                      final genres = genreSnapshot.data;
                      print(genres.length);
                      return Container(
                        height: 90.0,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: genres.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.all(10.0),
                              width: 160.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFD45253),
                                    Color(0xFF9E1F28),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9E1F28),
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  genres
                                      .elementAt(index)
                                      .kategoriaNev
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                FutureBuilder(
                  future: getTop10Movies(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Movie>> top10MoviesSnapshot) {
                    if (top10MoviesSnapshot.hasData) {
                      final top10Movies = top10MoviesSnapshot.data;
                      return ContentScroll(
                        movies: top10Movies,
                        title: 'Top 10-es lista',
                        imageHeight: 250.0,
                        imageWidth: 150.0,
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                SizedBox(height: 10.0),
                ContentScroll(
                  movies: movies,
                  title: 'Összes film',
                  imageHeight: 250.0,
                  imageWidth: 150.0,
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_netflix_ui_redesign/models/actors_model.dart';
import 'package:flutter_netflix_ui_redesign/models/genres_model.dart';
import 'package:flutter_netflix_ui_redesign/models/movie_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:string_validator/string_validator.dart';
import 'dart:html' as html;

class NewMovieScreen extends StatefulWidget {
  @override
  _NewMovieScreenState createState() => _NewMovieScreenState();
}

class _NewMovieScreenState extends State<NewMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  int selectedActorId;
  int selectedGenreId;
  TextEditingController movieNameController = TextEditingController();
  TextEditingController movieDescriptionController = TextEditingController();
  TextEditingController movieCoverURLController = TextEditingController();
  TextEditingController movieRatingController = TextEditingController();
  //screens
  TextEditingController screen1Controller = TextEditingController();
  TextEditingController screen2Controller = TextEditingController();
  TextEditingController screen3Controller = TextEditingController();
  TextEditingController screen4Controller = TextEditingController();
  TextEditingController screen5Controller = TextEditingController();

  List<FilmKepek> getSelectedFilmKepek() {
    List<FilmKepek> result = [];
    if (screen1Controller.text != null &&
        screen1Controller.text.trim().isNotEmpty) {
      result.add(FilmKepek(kepUrl: screen1Controller.text));
    }
    if (screen2Controller.text != null &&
        screen2Controller.text.trim().isNotEmpty) {
      result.add(FilmKepek(kepUrl: screen2Controller.text));
    }
    if (screen3Controller.text != null &&
        screen3Controller.text.trim().isNotEmpty) {
      result.add(FilmKepek(kepUrl: screen3Controller.text));
    }
    if (screen4Controller.text != null &&
        screen4Controller.text.trim().isNotEmpty) {
      result.add(FilmKepek(kepUrl: screen4Controller.text));
    }
    if (screen5Controller.text != null &&
        screen5Controller.text.trim().isNotEmpty) {
      result.add(FilmKepek(kepUrl: screen5Controller.text));
    }
    return result;
  }

  Future<void> _showDialog(Movie movie) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(movie.nev),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Biztos hozzászeretnéd adni a következő filmet?'),
                Text(movie.nev),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Felvétel'),
              onPressed: () {
                addNewMovie(movie);
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            label: Row(
              children: [
                Icon(FontAwesomeIcons.plus),
                SizedBox(
                  width: 10,
                ),
                Text('Hozzáadás'),
              ],
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                final newMovie = Movie(
                  filmId: 0,
                  nev: movieNameController.text,
                  leiras: movieDescriptionController.text,
                  boritoKepUrl: movieCoverURLController.text,
                  ertekeles: int.parse(movieRatingController.text),
                  szinesz: selectedActorId.toString(),
                  kategoria: selectedGenreId.toString(),
                  filmKepek: getSelectedFilmKepek(),
                );
                _showDialog(newMovie);
              }
            },
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Új film hozzáadása'),
      ),
      body: FutureBuilder(
        future: getActors(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Actor>> actorsSnapshot) {
          if (actorsSnapshot.hasData) {
            final actors = actorsSnapshot.data;
            return FutureBuilder(
                future: getGenres(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Genre>> genreSnapshot) {
                  if (genreSnapshot.hasData) {
                    final genres = genreSnapshot.data;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(56),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: movieNameController,
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.video),
                                  hintText: 'Mi az új film neve?',
                                  labelText: 'Film neve',
                                ),
                                validator: (value) {
                                  return isAlpha(value) ? null : 'Hibás név';
                                },
                              ),
                              TextFormField(
                                controller: movieDescriptionController,
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.fileAlt),
                                  hintText: 'Mi az új film leirasa?',
                                  labelText: 'Film leirasa',
                                ),
                                validator: (value) {
                                  return isAlpha(value) ? null : 'Hibás leiras';
                                },
                              ),
                              TextFormField(
                                controller: movieCoverURLController,
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.portrait),
                                  hintText: 'Mi az új film boritókép URL-je?',
                                  labelText: 'Film boritókép URL-je?',
                                ),
                                validator: (value) {
                                  return isURL(value) ? null : 'Hibás URL';
                                },
                              ),
                              TextFormField(
                                controller: movieRatingController,
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.starHalfAlt),
                                  hintText: 'Mi az új film értékelése?',
                                  labelText: 'Film értékelése (1-10)?',
                                ),
                                validator: (value) {
                                  return isNumeric(value) &&
                                          int.parse(value) >= 1 &&
                                          int.parse(value) <= 10
                                      ? null
                                      : 'Hibás érték';
                                },
                              ),
                              FormField(
                                builder: (state) {
                                  return ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    leading: Icon(FontAwesomeIcons.userAlt),
                                    title: Text('Szinész'),
                                    subtitle: state.errorText == null
                                        ? null
                                        : Text(
                                            'Nincs érték kiválasztva',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    children: actors
                                        .map(
                                          (actor) => RadioListTile(
                                            groupValue: selectedActorId,
                                            value: actor.szineszId,
                                            selected: selectedActorId != null &&
                                                selectedActorId ==
                                                    actor.szineszId,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedActorId = value;
                                              });
                                              state.didChange(true);
                                              state.validate();
                                            },
                                            title: Text(actor.neve +
                                                ' (${actor.kor} éves)'),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                                validator: (_) {
                                  return selectedActorId == null ? 'XXX' : null;
                                },
                              ),
                              FormField(
                                builder: (state) {
                                  return ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    leading:
                                        Icon(FontAwesomeIcons.theaterMasks),
                                    title: Text('Kategória'),
                                    subtitle: state.errorText == null
                                        ? null
                                        : Text(
                                            'Nincs érték kiválasztva',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                    children: genres
                                        .map(
                                          (genre) => RadioListTile(
                                            groupValue: selectedGenreId,
                                            value: genre.kategoriaId,
                                            selected: selectedGenreId != null &&
                                                selectedGenreId ==
                                                    genre.kategoriaId,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedGenreId = value;
                                              });
                                              state.didChange(true);
                                              state.validate();
                                            },
                                            title: Text(genre.kategoriaNev),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                                validator: (_) {
                                  return selectedGenreId == null ? 'XXX' : null;
                                },
                              ),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                leading: Icon(FontAwesomeIcons.solidImages),
                                title: Text('Jelenetek'),
                                children: [
                                  TextFormField(
                                    controller: screen1Controller,
                                    decoration: const InputDecoration(
                                      icon: CircleAvatar(
                                        child: Text('1'),
                                      ),
                                      hintText: 'URL 1',
                                      labelText: 'URL 1',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: screen2Controller,
                                    decoration: const InputDecoration(
                                      icon: CircleAvatar(
                                        child: Text('2'),
                                      ),
                                      hintText: 'URL 2',
                                      labelText: 'URL 2',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: screen3Controller,
                                    decoration: const InputDecoration(
                                      icon: CircleAvatar(
                                        child: Text('3'),
                                      ),
                                      hintText: 'URL 3',
                                      labelText: 'URL 3',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: screen4Controller,
                                    decoration: const InputDecoration(
                                      icon: CircleAvatar(
                                        child: Text('4'),
                                      ),
                                      hintText: 'URL 4',
                                      labelText: 'URL 4',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: screen5Controller,
                                    decoration: const InputDecoration(
                                      icon: CircleAvatar(
                                        child: Text('5'),
                                      ),
                                      hintText: 'URL 5',
                                      labelText: 'URL 5',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

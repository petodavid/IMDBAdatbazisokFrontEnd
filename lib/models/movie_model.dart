// To parse this JSON data, do
//
//     final movie = movieFromJson(jsonString);
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Movie> movieFromJson(String str) =>
    List<Movie>.from(json.decode(str).map((x) => Movie.fromJson(x)));

String movieToJson(List<Movie> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Movie {
  Movie({
    this.filmId,
    this.kategoria,
    this.ertekeles,
    this.szinesz,
    this.nev,
    this.leiras,
    this.boritoKepUrl,
    this.filmKepek,
  });

  final int filmId;
  final String kategoria;
  final int ertekeles;
  final String szinesz;
  final String nev;
  final String leiras;
  final String boritoKepUrl;
  final List<FilmKepek> filmKepek;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        filmId: json["film_id"] == null ? null : json["film_id"],
        kategoria: json["kategoria"] == null ? null : json["kategoria"],
        ertekeles: json["ertekeles"] == null ? null : json["ertekeles"],
        szinesz: json["szinesz"] == null ? null : json["szinesz"],
        nev: json["nev"] == null ? null : json["nev"],
        leiras: json["leiras"] == null ? null : json["leiras"],
        boritoKepUrl:
            json["boritoKepURL"] == null ? null : json["boritoKepURL"],
        filmKepek: json["filmKepek"] == null
            ? null
            : List<FilmKepek>.from(
                json["filmKepek"].map((x) => FilmKepek.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "film_id": filmId == null ? null : filmId,
        "kategoria": kategoria == null ? null : kategoria,
        "ertekeles": ertekeles == null ? null : ertekeles,
        "szinesz": szinesz == null ? null : szinesz,
        "nev": nev == null ? null : nev,
        "leiras": leiras == null ? null : leiras,
        "boritoKepURL": boritoKepUrl == null ? null : boritoKepUrl,
        "filmKepek": filmKepek == null
            ? null
            : List<dynamic>.from(filmKepek.map((x) => x.toJson())),
      };
}

class FilmKepek {
  FilmKepek({
    this.kepUrl,
  });

  final String kepUrl;

  factory FilmKepek.fromJson(Map<String, dynamic> json) => FilmKepek(
        kepUrl: json["kepURL"] == null ? null : json["kepURL"],
      );

  Map<String, dynamic> toJson() => {
        "kepURL": kepUrl == null ? null : kepUrl,
      };
}

Future<List<Movie>> getMovies() async {
  var client = http.Client();
  try {
    var uriResponse = await client.get(
      'https://imdbadatabazisok.azurewebsites.net/api/Movies',
    );
    return (movieFromJson(uriResponse.body));
  } finally {
    client.close();
  }
}

Future<List<Movie>> getTop10Movies() async {
  var client = http.Client();
  try {
    var uriResponse = await client.get(
      'https://imdbadatabazisok.azurewebsites.net/api/Movies/top10',
    );
    return (movieFromJson(uriResponse.body));
  } finally {
    client.close();
  }
}

void addNewMovie(Movie movie) async {
  var client = http.Client();
  try {
    final response = await client.post(
      'https://imdbadatabazisok.azurewebsites.net/api/Movies/new',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "film_id": 0,
        "kategoria": "${movie.kategoria}",
        "ertekeles": movie.ertekeles,
        "szinesz": "${movie.szinesz}",
        "nev": movie.nev,
        "leiras": movie.leiras,
        "boritoKepURL": movie.boritoKepUrl,
        "filmKepek": movie.filmKepek
      }),
    );
    print(response.statusCode);
  } finally {
    client.close();
  }
}

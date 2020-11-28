// To parse this JSON data, do
//
//     final genre = genreFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

List<Genre> genreFromJson(String str) =>
    List<Genre>.from(json.decode(str).map((x) => Genre.fromJson(x)));

String genreToJson(List<Genre> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Genre {
  Genre({
    this.kategoriaId,
    this.kategoriaNev,
  });

  final int kategoriaId;
  final String kategoriaNev;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        kategoriaId: json["kategoria_id"] == null ? null : json["kategoria_id"],
        kategoriaNev:
            json["kategoriaNev"] == null ? null : json["kategoriaNev"],
      );

  Map<String, dynamic> toJson() => {
        "kategoria_id": kategoriaId == null ? null : kategoriaId,
        "kategoriaNev": kategoriaNev == null ? null : kategoriaNev,
      };
}

Future<List<Genre>> getGenres() async {
  var client = http.Client();
  try {
    var uriResponse = await client.get(
      'https://imdbadatabazisok.azurewebsites.net/api/Genres',
    );
    return (genreFromJson(uriResponse.body));
  } finally {
    client.close();
  }
}

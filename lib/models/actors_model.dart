// To parse this JSON data, do
//
//     final actor = actorFromJson(jsonString);
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Actor> actorFromJson(String str) =>
    List<Actor>.from(json.decode(str).map((x) => Actor.fromJson(x)));

String actorToJson(List<Actor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Actor {
  Actor({
    this.szineszId,
    this.neve,
    this.kor,
  });

  final int szineszId;
  final String neve;
  final String kor;

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        szineszId: json["szinesz_id"] == null ? null : json["szinesz_id"],
        neve: json["neve"] == null ? null : json["neve"],
        kor: json["kor"] == null ? null : json["kor"],
      );

  Map<String, dynamic> toJson() => {
        "szinesz_id": szineszId == null ? null : szineszId,
        "neve": neve == null ? null : neve,
        "kor": kor == null ? null : kor,
      };
}

Future<List<Actor>> getActors() async {
  var client = http.Client();
  try {
    var uriResponse = await client.get(
      'https://imdbadatabazisok.azurewebsites.net/api/Actors',
    );
    return (actorFromJson(uriResponse.body));
  } finally {
    client.close();
  }
}

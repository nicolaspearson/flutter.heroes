import 'dart:convert';

Heroes heroesFromJson(String str) {
  final jsonData = json.decode(str);
  return Heroes.fromJson(jsonData);
}

class Heroes {
  final List<Hero> heroes;

  Heroes({
    this.heroes,
  });

  factory Heroes.fromJson(List<dynamic> parsedJson) {
    List<Hero> heroes = new List<Hero>();
    heroes = parsedJson.map((i) => Hero.fromJson(i)).toList();
    return new Heroes(heroes: heroes);
  }
}

Hero heroFromJson(String str) {
  final jsonData = json.decode(str);
  return Hero.fromJson(jsonData);
}

String heroToJson(Hero data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Hero {
  int id;
  String name;
  String identity;
  String hometown;
  int age;
  String createdAt;
  String updatedAt;
  String deletedAt;

  Hero(
      {this.id,
      this.name,
      this.identity,
      this.hometown,
      this.age,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory Hero.fromJson(Map<String, dynamic> parsedJson) {
    return Hero(
      id: parsedJson['id'],
      name: parsedJson['name'],
      identity: parsedJson['identity'],
      hometown: parsedJson['hometown'],
      age: parsedJson['age'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
      deletedAt: parsedJson['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "identity": identity,
        "hometown": hometown,
        "age": age,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
      };
}

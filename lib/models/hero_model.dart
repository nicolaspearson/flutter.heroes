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
}

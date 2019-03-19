import 'dart:convert';

HeroItem heroFromJson(String str) {
  final jsonData = json.decode(str);
  return HeroItem.fromJson(jsonData);
}

String heroToJson(HeroItem data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

List<HeroItem> heroesFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<HeroItem>.from(jsonData.map((x) => HeroItem.fromJson(x)));
}

String heroesToJson(List<HeroItem> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class HeroItem {
  int id;
  String name;
  String identity;
  String hometown;
  int age;
  String createdAt;
  String updatedAt;
  String deletedAt;

  HeroItem(
      {this.id,
      this.name,
      this.identity,
      this.hometown,
      this.age,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory HeroItem.fromJson(Map<String, dynamic> parsedJson) {
    return HeroItem(
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

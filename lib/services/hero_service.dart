import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:heroes/models/hero_model.dart';
import 'dart:io';

Future<String> _loadSampleHeroAsset() async {
  return await rootBundle.loadString('assets/hero.json');
}

Future loadSampleHero() async {
  String jsonString = await _loadSampleHeroAsset();
  HeroItem hero = heroFromJson(jsonString);
  print("hero: " + hero.name);
}

Future<String> _loadSampleHeroesAsset() async {
  return await rootBundle.loadString('assets/heroes.json');
}

Future loadSampleHeroes() async {
  String jsonString = await _loadSampleHeroesAsset();
  List<HeroItem> heroList = heroesFromJson(jsonString);
  for (var hero in heroList) {
    print("hero: " + hero.name);
  }
}

String url = 'http://localhost:8000';

Future<HeroItem> getHero(int heroId) async {
  final response = await http.get('$url/hero?id=' + heroId.toString());
  return heroFromJson(response.body);
}

Future<List<HeroItem>> getHeroes() async {
  final response = await http.get('$url/heroes');
  return heroesFromJson(response.body);
}

Future<http.Response> createHero(HeroItem hero) async {
  return await http.post('$url/hero',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
      body: heroToJson(hero));
}

Future<http.Response> updateHero(int heroId, HeroItem hero) async {
  return await http.put('$url/hero/' + heroId.toString(),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
      body: heroToJson(hero));
}

Future<http.Response> deleteHero(int heroId) async {
  return await http.delete('$url/hero' + heroId.toString());
}

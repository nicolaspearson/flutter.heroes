import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:heroes/models/hero_model.dart';

Future<String> _loadAHeroAsset() async {
  return await rootBundle.loadString('assets/hero.json');
}

Future loadHero() async {
  String jsonString = await _loadAHeroAsset();
  Hero hero = heroFromJson(jsonString);
  print("hero: " + hero.name);
}

Future<String> _loadHeroesAsset() async {
  return await rootBundle.loadString('assets/heroes.json');
}

Future loadHeroes() async {
  String jsonString = await _loadHeroesAsset();
  Heroes heroList = heroesFromJson(jsonString);
  for (var hero in heroList.heroes) {
    print("hero: " + hero.name);
  }
}

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:heroes/models/hero_model.dart';

Future<String> _loadAHeroAsset() async {
  return await rootBundle.loadString('assets/hero.json');
}

Future loadHero() async {
  String jsonString = await _loadAHeroAsset();
  final jsonResponse = json.decode(jsonString);
  Hero hero = new Hero.fromJson(jsonResponse);
  print("hero: " + hero.name);
}

Future<String> _loadHeroesAsset() async {
  return await rootBundle.loadString('assets/heroes.json');
}

Future loadHeroes() async {
  String jsonString = await _loadHeroesAsset();
  final jsonResponse = json.decode(jsonString);
  Heroes heroList = Heroes.fromJson(jsonResponse);
  for (var hero in heroList.heroes) {
    print("hero: " + hero.name);
  }
}

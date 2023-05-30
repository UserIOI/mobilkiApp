import 'package:hive/hive.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/skill.dart';
import 'dart:io';
import '../note.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  List<Skill> skillList = [];

  @HiveField(2)
  List<String> noteListTitle = [];

  @HiveField(3)
  List<String> noteListContent = [];

  @HiveField(4)
  String? investigatorImagePath;

  @HiveField(5)
  Map<String, String?> investigatorAboutData = {
    "Name": "",
    "Occupation": "",
    "Age": "",
    "Residence": "",
    "PlaceOfBirth": "",
  };

  @HiveField(6)
  List<String> characteristic = [
    "STR",
    "CON",
    "DEX",
    "INT",
    "SIZ",
    "POW",
    "APP",
    "EDU",
  ];

  @HiveField(7)
  List<int> characteristicLevel = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
}

// use
// flutter packages pub run build_runner build
// in terminal to rebuild the adapter
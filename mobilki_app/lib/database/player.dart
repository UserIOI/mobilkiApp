import 'package:hive/hive.dart';
import 'dart:io';
import '../note.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  List<String> skillList = [
    "Accounting;5;0;false",
    "Anthropology;1;0;false",
    "Appraise;5;0;false",
    "Archaeology;1;0;false",
    "Art/Craft;5;0;false",
    "Charm;15;0;false",
    "Climb;40;0;false",
    "Credit Rating;0;0;false",
    "Cthulhu Mythos;0;0;false",
    "Disguise;5;0;false",
    "Dodge;2;0;false", // TODO getDEX
    "Drive Auto;20;0;false",
    "Electrical Repair;10;0;false",
    "Fast Talk;5;0;false",
    "Fighting (Brawl);25;0;false",
    "Fighting (Firearms);25;0;false",
    "First Aid;30;0;false",
    "History;5;0;false",
    "Intimidate;15;0;false",
    "Jump;25;0;false",
    "Language (Other);1;0;false",
    "Language (Own);5;0;false", // TODO getEDU
    "Law;5;0;false",
    "Library Use;20;0;false",
    "Listen;20;0;false",
    "Locksmith;1;0;false",
    "Mechanical Repair;10;0;false",
    "Medicine;1;0;false",
    "Natural History;10;0;false",
    "Navigate;10;0;false",
    "Occult;5;0;false",
    "Operate Heavy Machinery;1;0;false",
    "Persuade;10;0;false",
    "Pilot;1;0;false",
    "Psychology;5;0;false",
    "Psychoanalysis;1;0;false",
    "Ride;5;0;false",
    "Science;1;0;false",
    "Sleight of Hand;10;0;false",
    "Spot Hidden;25;0;false",
    "Stealth;20;0;false",
    "Survival;10;0;false",
    "Swim;25;0;false",
    "Throw;25;0;false",
    "Track;10;0;false",
  ];

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

  // fields 8-11 are used for EquipmentView
  @HiveField(8)
  List characterWealth = [
    0.0, // money
    0.0, // spending
    "week", // time period for spending
  ];

  @HiveField(9)
  List<String> weapons = [];

  @HiveField(10)
  List<String> backpackItems = [];

  @HiveField(11)
  List<String> assets = [];
}

// use
// flutter packages pub run build_runner build
// in terminal to rebuild the adapter
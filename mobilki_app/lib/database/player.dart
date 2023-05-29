import 'package:hive/hive.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/skill.dart';

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
}

// use
// flutter packages pub run build_runner build
// in terminal to rebuild the adapter
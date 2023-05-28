import 'package:hive/hive.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/skills.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  List<Skills> skillList = [];

}

// use
// flutter packages pub run build_runner build
// in terminal to rebuild the adapter
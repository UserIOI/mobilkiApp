import 'package:flutter/material.dart';
import 'skill.dart';
import 'skill_card.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({Key? key}) : super(key: key);

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  List<Skill> skillList = [];
  int columnCount = 1;

  @override
  Widget build(BuildContext context) {
    skillList = skillList.isEmpty ? getDefaultSkills() : skillList;

    return SafeArea(
      child: ListView(
        children: generateSkillCards(columnCount),
      ),
    );
  }

  List<Widget> generateSkillCards(int columnCount) {
    return skillList.map((skill) => SkillCard(skill)).toList();
  }

  List<Skill> getDefaultSkills() {
    List<Skill> skillList = [
      Skill("Accounting", 5, false),
          Skill("Anthropology", 1, false),
          Skill("Appraise", 5, false),
          Skill("Archaeology", 1, false),
          Skill("Art/Craft", 5, false),
          Skill("Charm", 15, false),
          Skill("Climb", 40, false),
          Skill("Credit Rating", 0, false),
          Skill("Cthulhu Mythos", 0, false),
          Skill("Disguise", 5, false),
          Skill("Dodge", (getDEX() ~/ 2), false),
          Skill("Drive Auto", 20, false),
          Skill("Electrical Repair", 10, false),
          Skill("Fast Talk", 5, false),
          Skill("Fighting (Brawl)", 25, false),
          Skill("Fighting (Firearms)", 25, false),
          Skill("First Aid", 30, false),
          Skill("History", 5, false),
          Skill("Intimidate", 15, false),
          Skill("Jump", 25, false),
          Skill("Language (Other)", 1, false),
          Skill("Language (Own)", getEDU() * 5, false),
          Skill("Law", 5, false),
          Skill("Library Use", 20, false),
          Skill("Listen", 20, false),
          Skill("Locksmith", 1, false),
          Skill("Mechanical Repair", 10, false),
          Skill("Medicine", 1, false),
          Skill("Natural History", 10, false),
          Skill("Navigate", 10, false),
          Skill("Occult", 5, false),
          Skill("Operate Heavy Machinery", 1, false),
          Skill("Persuade", 10, false),
          Skill("Pilot", 1, false),
          Skill("Psychology", 5, false),
          Skill("Psychoanalysis", 1, false),
          Skill("Ride", 5, false),
          Skill("Science", 1, false),
          Skill("Sleight of Hand", 10, false),
          Skill("Spot Hidden", 25, false),
          Skill("Stealth", 20, false),
          Skill("Survival", 10, false),
          Skill("Swim", 25, false),
          Skill("Throw", 25, false),
          Skill("Track", 10, false),
    ];
    return skillList;
  }

  int getDEX() {
    // TODO: get DEX
    return 10;
  }

  int getEDU() {
    // TODO: get EDU
    return 10;
  }
}
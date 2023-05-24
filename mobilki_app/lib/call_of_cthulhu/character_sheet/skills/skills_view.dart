import 'package:flutter/material.dart';
import 'skill.dart';
import 'skill_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({Key? key}) : super(key: key);

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  List<Skill> skillList = [];
  List<Skill> displayableList = [];
  int columnCount = 2;

  @override
  Widget build(BuildContext context) {
    if(skillList.isEmpty) {
      skillList = getDefaultSkills();
      displayableList = skillList;
    }

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(
                onChanged: handleQuery,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.clear),
                  ),
                ),
              )),
              PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "new_ability",child: Text("Add new ability"),),
                    const PopupMenuItem(value: "change_column_count", child: Text("Change column count")),
                  ],
                  onSelected: (value) {
                      switch(value) {
                          case "new_ability" :
                              //showNewAbilityDialog(context);
                              break;
                          case "change_column_count":
                              //showChangeColumnCountDialog(context);
                              break;
                      }
                  },
              ),
            ],
          ),
          Flexible(
            child: MasonryGridView.count(
              itemCount: displayableList.length,
              crossAxisCount: columnCount,
              itemBuilder: (context, index) {
                final skill = displayableList[index];
                return SkillCard(skill);
              }),
            ),
        ],
      ),
      );
  }

  // currently not used
  // kept just in case I wanted to change staggeredGrid back to listView
  List<Widget> generateSkillCards(int columnCount) {
    List<List<Skill>> dividedList = [];
    double length = displayableList.length / columnCount;
    for(int i = 0; i < length.ceil() ; i++) {
        dividedList.add([]);
    }
    for(int i = 0; i < displayableList.length; i++) {
        dividedList[i ~/ columnCount].add(displayableList[i]);
    }
    List<Widget> result = [];
    for(int i = 0; i < dividedList.length; i++) {
        List<Widget> childrenList = [];
        childrenList = dividedList[i].map((skill) => Expanded(child: SkillCard(skill))).toList();
        result.add(Row(
          children: childrenList,
        ));
    }
    return result;
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

  void handleQuery(String query) {
    setState(() {
      if(query == "") {
        displayableList = skillList;
      } else {
        displayableList = [];
        for (var skill in skillList) {
          if (skill.name.toLowerCase().startsWith(query.toLowerCase())) {
            displayableList.add(skill);
          }
        }
      }
    });
  }
}
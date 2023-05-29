import 'package:flutter/material.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/change_column_count_dialog.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/new_skill_route.dart';
import 'package:mobilki_app/main.dart';
import 'skill.dart';
import 'skill_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobilki_app/database/boxes.dart';
import 'package:mobilki_app/database/player.dart';

// uses package flutter_stagger_grid_view 0.6.2
// https://pub.dev/packages/flutter_staggered_grid_view

class SkillsView extends StatefulWidget {
  final String playerName;
  const SkillsView({Key? key, required this.playerName}) : super(key: key);

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  List<Skill> skillList = []; // List of all skills
  List<Skill> displayableList = []; // List of skills available for display, may change when handling search quarries
  int columnCount = 2; // Number of columns displaying skills
  TextEditingController searchBarController = TextEditingController(); // Controller for search TextField

  @override
  void initState() {
    searchBarController.addListener(() { // initializing search bar listener
      refreshDisplayableList();
    });
    skillList = getSkillsFromPlayer(); // loading skills from box
    refreshDisplayableList(); // showing skills

    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(
                controller: searchBarController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchBarController.text = "";
                      refreshDisplayableList();
                      },
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
                              openNewSkillRoute();
                              break;
                          case "change_column_count":
                              showChangeColumnCountDialog(context, columnCount).then((value) {
                                if(value != null) {
                                  setState(() {
                                    columnCount = value;
                                  });
                                }
                              });
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
                return SkillCard(skill: skill, callback: () { saveChanges(); });
              }),
            ),
        ],
      ),
    );
  }

  List<Skill> getSkillsFromPlayer() {
    if(!boxPlayers.containsKey(playerName)) {
      return [];
    }
    Player player = boxPlayers.get(playerName);
    return player.skillList.map((skill) => Skill.fromString(skill)).toList();
  }

  void saveChanges() {
    if(boxPlayers.containsKey(playerName)) {
      Player player = boxPlayers.get(playerName);
      player.skillList = skillList.map((skill) => skill.toString()).toList();
      boxPlayers.put(playerName, player);
    }
  }

  void refreshDisplayableList() { // refreshed displayableList taking into account current query in search bar
    setState(() {
      String query = searchBarController.text;
      if(query == "") {
        displayableList = skillList;
      } else {
        displayableList = [];
        for (var skill in skillList) {
          if (skill.name.toLowerCase().contains(query.toLowerCase())) {
            displayableList.add(skill);
          }
        }
      }
    });
  }

  void openNewSkillRoute() async {
    List<String> nameList = skillList.map((skill) => skill.name).toList();
    Skill? skill = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewSkillRoute(nameList: nameList)),
    );

    if(skill != null) {
      setState(() {
        int index;
        for(index = 0; index < skillList.length; index++) {
          if(skillList[index].name.toLowerCase().compareTo(skill.name.toLowerCase()) > 0) {
            break;
          }
        }
        skillList.insert(index, skill);
        refreshDisplayableList();
        saveChanges();
      });
    }
  }
}
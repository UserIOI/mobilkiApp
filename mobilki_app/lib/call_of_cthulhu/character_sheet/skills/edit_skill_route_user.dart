import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'skill.dart';

class EditSkillRouteUser extends StatefulWidget {
  final Skill skill;
  final List<String> nameList;
  const EditSkillRouteUser({Key? key, required this.skill, required this.nameList}) : super(key: key);

  @override
  State<EditSkillRouteUser> createState() => _EditSkillRouteUserState();
}

class _EditSkillRouteUserState extends State<EditSkillRouteUser> {
  int baseLevel = 0;
  int userLevel = 0;
  String name = "";
  bool isNameValid = true;
  bool areLevelsValid = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController baseLevelController = TextEditingController();
  TextEditingController userLevelController = TextEditingController();

  void update() {
    setState(() {
      if(name == widget.skill.name) { // has name not been changed?
        isNameValid = true;
      } else if(name.trim() == "") { // is name empty?
        isNameValid = false;
      } else if (name.contains(";")) { // does name contain ";" ? (it is used to save skill to string format)
        isNameValid = false;
      } else if (widget.nameList.contains(name)) { // is name not unique? (note that it has to be checked only if name is changed)
        isNameValid = false;
      } else {
        isNameValid = true;
      }

      if (baseLevel + userLevel > 99) { // is success chance > 99?
        areLevelsValid = false;
      } else {
        areLevelsValid = true;
      }
    });
  }

  void nameListener() {
    name = nameController.text;
    update();
  }

  void baseLevelListener() {
    baseLevel = baseLevelController.text.isEmpty ? 0 : int.parse(baseLevelController.text);
    update();
  }

  void userLevelListener() {
    userLevel = userLevelController.text.isEmpty ? 0 : int.parse(userLevelController.text);
    update();
  }

  void changeBaseLevel(level) {
    baseLevelController.removeListener(baseLevelListener);
    baseLevel = level;
    baseLevelController.text = "$baseLevel";
    baseLevelController.addListener(baseLevelListener);
    update();
  }

  void changeUserLevel(level) {
    userLevelController.removeListener(userLevelListener);
    userLevel = level;
    userLevelController.text = "$userLevel";
    userLevelController.addListener(userLevelListener);
    update();
  }

  @override
  void initState() {
    nameController.addListener(nameListener); // applying input listeners
    baseLevelController.addListener(baseLevelListener);
    userLevelController.addListener(userLevelListener);

    nameController.text = widget.skill.name; // this also updates local variables, because listeners aer already in place
    baseLevelController.text = widget.skill.baseLevel.toString();
    userLevelController.text = widget.skill.userLevel.toString();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    baseLevelController.dispose();
    userLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit skill"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Name:"),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Base level:"),
                Row(
                  children: [
                    IconButton(
                        onPressed: baseLevel > 0 ? () { changeBaseLevel(baseLevel - 1); } : null,
                        icon: const Icon(Icons.chevron_left)),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: baseLevelController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                        onPressed: baseLevel < 99 ? () { changeBaseLevel(baseLevel + 1); } : null,
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("User level:"),
                Row(
                  children: [
                    IconButton(
                        onPressed: userLevel > 0 ? () { changeUserLevel(userLevel - 1); } : null,
                        icon: const Icon(Icons.chevron_left)),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: userLevelController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                        onPressed: userLevel < 99 ? () { changeUserLevel(userLevel + 1); } : null,
                        icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Success chance is:"),
                Text(
                  "${baseLevel + userLevel}",
                  style: TextStyle(
                    color: baseLevel + userLevel <= 99 ? Colors.black : Colors.red,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () { Navigator.pop(context, "delete"); },
              child: const Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () { Navigator.pop(context, "cancelled");},
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: (isNameValid && areLevelsValid) ? () {
                widget.skill.baseLevel = baseLevel;
                widget.skill.userLevel = userLevel;
                String result = "changed";
                if(widget.skill.name != name) {
                  result = "reposition";
                  widget.skill.name = name;
                }
                Navigator.pop(context, result);
              } : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

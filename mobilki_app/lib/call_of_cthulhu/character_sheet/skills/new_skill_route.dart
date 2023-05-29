import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'skill.dart';

class NewSkillRoute extends StatefulWidget {
  final List<String> nameList;
  const NewSkillRoute({Key? key, required this.nameList}) : super(key: key);

  @override
  State<NewSkillRoute> createState() => _NewSkillRouteState();
}

class _NewSkillRouteState extends State<NewSkillRoute> {
  int baseLevel = 0;
  int userLevel = 0;
  String name = "";
  bool canBeSaved = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController baseLevelController = TextEditingController(text: "0");
  TextEditingController userLevelController = TextEditingController(text: "0");

  void update() {
    setState(() {
      if(name.trim() == "") { // is name not empty?
        canBeSaved = false;
      } else if (name.contains(";")) { // does name NOT contain ";" ? (it is used to save skill to string format)
        canBeSaved = false;
      } else if (widget.nameList.contains(name)) { // is name unique?
        canBeSaved = false;
      } else if (baseLevel + userLevel > 99) { // is success chance <= 99?
        canBeSaved = false;
      } else {
        canBeSaved = true;
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
    nameController.addListener(nameListener);
    baseLevelController.addListener(baseLevelListener);
    userLevelController.addListener(userLevelListener);
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
        title: const Text("Create a new skill"),
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
              onPressed: canBeSaved ? () {
                Skill skill = Skill(name, baseLevel, userLevel, true);
                Navigator.pop(context, skill);
              } : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

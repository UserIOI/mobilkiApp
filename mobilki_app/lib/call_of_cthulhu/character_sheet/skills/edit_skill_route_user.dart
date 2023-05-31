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
  String? nameErrorText;
  TextEditingController nameController = TextEditingController();
  TextEditingController baseLevelController = TextEditingController();
  TextEditingController userLevelController = TextEditingController();
  bool isSnackBarActive = false;

  void updateName() {
    setState(() {
      if(name == widget.skill.name) { // has name not been changed?
        isNameValid = true;
        nameErrorText = null;
      } else if(name == "") { // is name empty?
        isNameValid = false;
        nameErrorText = "Name cannot be empty";
      } else if (name.contains(";")) { // does name contain ";" ? (it is used to save skill to string format)
        isNameValid = false;
        nameErrorText = 'Name cannot contain ";" symbol';
      } else if (widget.nameList.contains(name)) { // is name not unique? (note that it has to be checked only if name is changed)
        isNameValid = false;
        nameErrorText = 'Name "$name" is already taken';
      } else {
        isNameValid = true;
        nameErrorText = null;
      }
    });
  }

  void updateLevels() {
    setState(() {
      if (baseLevel + userLevel > 99) { // is success chance <= 99?
        areLevelsValid = false;
        if(!isSnackBarActive) { // New SnackBar is shown only, if there is no active snack bar
          isSnackBarActive = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Success chance has to be 99 at most'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger
                    .of(context)
                    .hideCurrentSnackBar;
              },
            ),
          ))
              .closed.then((reason) { // if SnackBar is closed, new one can be shown
            isSnackBarActive = false;
          });
        }
      } else {
        areLevelsValid = true;
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
  }

  void nameListener() {
    if(nameController.text != name) {
      name = nameController.text.trim();
      updateName();
    }
  }

  void baseLevelListener() {
    baseLevel = baseLevelController.text.isEmpty ? 0 : int.parse(baseLevelController.text);
    updateLevels();
  }

  void userLevelListener() {
    userLevel = userLevelController.text.isEmpty ? 0 : int.parse(userLevelController.text);
    updateLevels();
  }

  void changeBaseLevel(level) {
    baseLevelController.removeListener(baseLevelListener);
    baseLevel = level;
    baseLevelController.text = "$baseLevel";
    baseLevelController.addListener(baseLevelListener);
    updateLevels();
  }

  void changeUserLevel(level) {
    userLevelController.removeListener(userLevelListener);
    userLevel = level;
    userLevelController.text = "$userLevel";
    userLevelController.addListener(userLevelListener);
    updateLevels();
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Expanded(
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        decoration: InputDecoration(
                          errorText: nameErrorText,
                          hintText: "Edit name",
                        ),
                      ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Base level:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 136,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: baseLevel > 0 ? () { changeBaseLevel(baseLevel - 1); } : null,
                              icon: const Icon(Icons.chevron_left)),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: baseLevelController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                              onPressed: baseLevel < 99 ? () { changeBaseLevel(baseLevel + 1); } : null,
                              icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Player level:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 136,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: userLevel > 0 ? () { changeUserLevel(userLevel - 1); } : null,
                              icon: const Icon(Icons.chevron_left)),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: userLevelController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                              onPressed: userLevel < 99 ? () { changeUserLevel(userLevel + 1); } : null,
                              icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Success chance:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 136,
                      child: Center(
                        child: Text(
                          "${baseLevel + userLevel}",
                          style: TextStyle(
                            fontSize: 20,
                            color: baseLevel + userLevel <= 99 ? Colors.black : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                      onPressed: () async {
                        showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete skill?"),
                              content: Text('You are going to delete "${widget.skill.name}". Are you sure?'),
                              actions: [
                                TextButton(
                                    onPressed: () { Navigator.of(context).pop(false); },
                                    child: const Text("Cancel"),
                                ),
                                TextButton(
                                    onPressed: () { Navigator.of(context).pop(true); },
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          }
                        ).then((result) {
                          if(result != null && result == true) {
                            Navigator.pop(context, "delete");
                          }
                        });
                        //Navigator.pop(context, "delete");
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () { Navigator.pop(context, "cancelled"); },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          disabledBackgroundColor: Colors.green.withOpacity(.8)
                      ),
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
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'skill.dart';

class EditSkillRouteDefault extends StatefulWidget {
  final Skill skill; // Skill object that the user wants to edit, required
  const EditSkillRouteDefault({Key? key, required this.skill}) : super(key: key);

  @override
  State<EditSkillRouteDefault> createState() => _EditSkillRouteDefaultState();
}

class _EditSkillRouteDefaultState extends State<EditSkillRouteDefault> {
  int userLevel = 0; // Local user level displayed by the dialog, this value is saved into skill object if "Save" button is clicked
  bool isLevelValid = true; // Controls if the "Save" button is active
  TextEditingController userLevelController = TextEditingController(); // Controller used to change and save the value in the TextField
  bool isSnackBarActive = false;

  @override
  void initState() {
    super.initState();
    userLevel = widget.skill.userLevel;
    userLevelController = TextEditingController(text: "$userLevel");
    userLevelController.addListener(userLevelListener);
  }

  void userLevelListener() {
    userLevel = userLevelController.text.isEmpty ? 0 : int.parse(userLevelController.text);
    updateUserLevel();
  }

  @override
  void dispose() {
    userLevelController.dispose();
    super.dispose();
  }

  void updateUserLevel() {
    setState(() {
      if (widget.skill.baseLevel + userLevel > 99) { // is success chance <= 99?
        isLevelValid = false;
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
        isLevelValid = true;
        ScaffoldMessenger.of(context).clearSnackBars();
      }
    });
  }

  void changeUserLevel(level) {
    userLevelController.removeListener(userLevelListener);
    userLevel = level;
    userLevelController.text = "$userLevel";
    userLevelController.addListener(userLevelListener);
    updateUserLevel();
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
                child: Text(
                  widget.skill.name,
                  style: const TextStyle(
                    fontSize: 40,
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
                      child: Center(
                        child: Text(
                          "${widget.skill.baseLevel}",
                          style: const TextStyle(
                            fontSize: 20,
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
                              onPressed: userLevel > 0 ? () { // setting onPressed to null disables the button
                                if (widget.skill.baseLevel + userLevel > 99) {
                                  changeUserLevel(99 - widget.skill.baseLevel);
                                } else {
                                  changeUserLevel(userLevel - 1);
                                }
                              } : null,
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
                              onPressed: widget.skill.baseLevel + userLevel < 99 ? () {
                                if (userLevel < 0) {
                                  changeUserLevel(0);
                                } else {
                                  changeUserLevel(userLevel + 1);
                                }
                              } : null,
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
                          "${widget.skill.baseLevel + userLevel}",
                          style: TextStyle(
                            fontSize: 20,
                            color: widget.skill.baseLevel + userLevel <= 99 ? Colors.black : Colors.red,
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
                      onPressed: () { Navigator.pop(context, false); },
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
                      onPressed: isLevelValid ? () {
                        widget.skill.userLevel = userLevel;
                        Navigator.pop(context, true);
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
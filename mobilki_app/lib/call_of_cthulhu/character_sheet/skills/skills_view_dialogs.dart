import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'skill.dart';

Future<bool?> showEditAbilityDialog(BuildContext context, Skill skill) {
  return showDialog<bool>(
    context: context,
    builder: (context) => EditAbilityDialog(
      skill: skill,
  ),
  );
}

class EditAbilityDialog extends StatefulWidget {
  final Skill skill;
  const EditAbilityDialog({Key? key, required this.skill}) : super(key: key);

  @override
  State<EditAbilityDialog> createState() => _EditAbilityDialogState();
}

class _EditAbilityDialogState extends State<EditAbilityDialog> {
  int userLevel = 0;
  bool canBeSaved = false;
  bool canBeLower = true;
  bool canBeHigher = true;
  String wrongLevelMessage = "No changes have been done";
  TextEditingController userLevelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userLevel = widget.skill.userLevel;
    userLevelController = TextEditingController(text: "$userLevel");
    userLevelController.addListener(textEditingListener);
    if(userLevel <= 0) {
      canBeLower = false;
    }
    if(widget.skill.baseSuccessChance + userLevel >= 99) {
      canBeHigher = false;
    }
  }

  void textEditingListener() {
    int level = userLevelController.text.isEmpty ? 0 : int.parse(userLevelController.text);
    if(level != userLevel) {
      updateUserLevel(level, false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userLevelController.dispose();
  }

  void updateUserLevel(int level, bool updateTextField) {
    setState(() {
      userLevel = level;
      if(updateTextField) {
        userLevelController.removeListener(textEditingListener);
        userLevelController.text = "$userLevel";
        userLevelController.addListener(textEditingListener);
      }
      if(widget.skill.userLevel == userLevel) {
        wrongLevelMessage = "No changes have been done";
        canBeSaved = false;
      } else if(userLevel < 0) {
        wrongLevelMessage = "User level has to be at least 0";
        canBeSaved = false;
      } else if(widget.skill.baseSuccessChance + userLevel > 99) {
        wrongLevelMessage = "Total score cannot exceed 99";
      } else {
        wrongLevelMessage = "";
        canBeSaved = true;
      }
      canBeLower = userLevel > 0 ? true : false;
      canBeHigher = widget.skill.baseSuccessChance + userLevel < 99 ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.skill.name),
      content:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Base level:"),
              Text(" ${widget.skill.baseSuccessChance}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("User level: "),
              Row(
                children: [
                  IconButton(
                      onPressed: canBeLower ? () {
                        if(widget.skill.baseSuccessChance + userLevel > 99) {
                          updateUserLevel(99 - widget.skill.baseSuccessChance, true);
                        } else {
                          updateUserLevel(userLevel - 1, true);
                        }
                      } : null,
                      icon: const Icon(Icons.chevron_left)),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: userLevelController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      //maxLength: 2,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                      onPressed: canBeHigher ? () {
                        if(userLevel < 0) {
                          updateUserLevel(0, true);
                        } else {
                          updateUserLevel(userLevel + 1, true);
                        }
                      } : null,
                      icon: const Icon(Icons.chevron_right)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Success chance:"),
              Text("${widget.skill.baseSuccessChance + userLevel}"),
            ],
          ),
          Text(wrongLevelMessage),
        ],
      ),
      actions: [
        TextButton(onPressed: () { Navigator.of(context).pop(false); }, child: const Text("Cancel")),
        TextButton(onPressed: canBeSaved ? () {
          widget.skill.updateUserLevel(userLevel);
          Navigator.of(context).pop(true);
        } : null, child: const Text("Save")),
      ],
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


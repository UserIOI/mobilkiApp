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
  final Skill skill; // Skill object that the user wants to edit, required
  const EditAbilityDialog({Key? key, required this.skill}) : super(key: key);

  @override
  State<EditAbilityDialog> createState() => _EditAbilityDialogState();
}

class _EditAbilityDialogState extends State<EditAbilityDialog> {
  int userLevel = 0; // Local user level displayed by the dialog, this value is saved into skill object if "Save" button is clicked
  bool canBeSaved = false; // Controls if the "Save" button is active
  bool canBeLower = true; // Controls if decrement button is active, it's true if userLevel is greater than 0
  bool canBeHigher = true; // Controls if increment button is active, it's true if total success chance is lower than 99
  String cannotSaveMessage = "No changes have been done"; // Message displayed explaining why changes cannot be saved
  TextEditingController userLevelController = TextEditingController(); // Controller used to change and save the value in the TextField

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
    int level = userLevelController.text.isEmpty ? 0 : int.parse(userLevelController.text); // Empty field is treated as level 0
    if(level != userLevel) { // updateUserLevel is only called if the new value is different to the old one
      updateUserLevel(level, false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userLevelController.dispose();
  }

  void updateUserLevel(int level, bool updateTextField) { // updateTextField is used to prevent text field listener updating the text field multiple times
    setState(() {
      userLevel = level;
      if(updateTextField) { // Listener is temporarily removed to not trigger more updates
        userLevelController.removeListener(textEditingListener);
        userLevelController.text = "$userLevel";
        userLevelController.addListener(textEditingListener);
      }
      // updating canBeSaved and cannotSaveMessage
      if(widget.skill.userLevel == userLevel) {
        cannotSaveMessage = "No changes have been done";
        canBeSaved = false;
      } else if(userLevel < 0) {
        cannotSaveMessage = "User level has to be at least 0";
        canBeSaved = false;
      } else if(widget.skill.baseSuccessChance + userLevel > 99) {
        cannotSaveMessage = "Total score cannot exceed 99";
      } else {
        cannotSaveMessage = "";
        canBeSaved = true;
      }
      // updating canBeLower and canBeHigher
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
                      onPressed: canBeLower ? () { // setting onPressed to null disables the button
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
          Text(cannotSaveMessage),
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
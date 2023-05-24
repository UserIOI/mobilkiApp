import 'package:flutter/material.dart';
import 'skill.dart';

Future<Skill?> showNewAbilityDialog(BuildContext context, List<Skill> skillList) {
  List<String> nameList = skillList.map((skill) => skill.name).toList();
  return showDialog<Skill>(
    context: context,
    builder: (context) => NewAbilityDialog(
      nameList: nameList,
    )
  );
}

class NewAbilityDialog extends StatefulWidget {
  final List<String> nameList;
  const NewAbilityDialog({Key? key, required this.nameList}) : super(key: key);

  @override
  State<NewAbilityDialog> createState() => _NewAbilityDialogState();
}

class _NewAbilityDialogState extends State<NewAbilityDialog> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

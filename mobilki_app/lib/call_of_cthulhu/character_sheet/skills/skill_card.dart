import 'package:flutter/material.dart';
import 'skill.dart';
import 'edit_ability_dialog.dart';

class SkillCard extends StatefulWidget {
  const SkillCard({Key? key, required this.skill, required this.callback}) : super(key: key);

  final Skill skill;
  final VoidCallback callback;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => showEditAbilityDialog(context, widget.skill).then((value) {
          if(value != null && value == true) {
            setState(() {});
            widget.callback();
          }
        }),
        child: ListTile(
          leading: widget.skill.isUserCreated ? const Icon(Icons.person) : null,
          title: Text(
              widget.skill.name,
              style: const TextStyle(
                  fontSize: 18
              )
          ),
          trailing: Text(
              (widget.skill.baseLevel + widget.skill.userLevel).toString(),
              style: TextStyle(
                fontSize: 18,
                color: widget.skill.userLevel == 0 ? Colors.grey[500] : Colors.grey[900],
                fontWeight: widget.skill.userLevel == 0 ? FontWeight.normal : FontWeight.bold,
              )
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'skill.dart';
import 'skills_view_dialogs.dart';

class SkillCard extends StatefulWidget {
  const SkillCard(this.skill, {Key? key}) : super(key: key);

  final Skill skill;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        onTap: () => showEditAbilityDialog(context, widget.skill).then((value) {
          if(value != null && value == true) {
            setState(() {});
          }
        }),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                    widget.skill.name,
                        style: const TextStyle(
                          fontSize: 18
                        )
                ),
              ),
              Text(
                  widget.skill.overallSuccessChance.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.skill.userLevel == 0 ? Colors.grey[500] : Colors.grey[900],
                    fontWeight: widget.skill.userLevel == 0 ? FontWeight.normal : FontWeight.bold,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
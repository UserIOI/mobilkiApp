import 'package:flutter/material.dart';
import 'skill.dart';

class SkillCard extends StatelessWidget {
  const SkillCard(this.skill, {Key? key}) : super(key: key);

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(skill.name),
          Text(
              skill.overallSuccessChance.toString(),
              style: TextStyle(
                color: skill.userLevel == 0 ? Colors.grey[700] : Colors.grey[900],
              )
          )
        ],
      ),
    );
  }
}
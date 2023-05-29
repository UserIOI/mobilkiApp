import 'package:flutter/material.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/skills/edit_skill_route_default.dart';
import 'skill.dart';

class SkillCard extends StatefulWidget {
  const SkillCard({Key? key, required this.skill, required this.saveChangesCallback}) : super(key: key);

  final Skill skill;
  final VoidCallback saveChangesCallback;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: openEditSkillRoute,
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

  void openEditSkillRoute() async {
    if(widget.skill.isUserCreated) {
      // TODO edit user skill
    } else {
      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditSkillRouteDefault(skill: widget.skill)),
      );
      if(result != null && result == true) {
        setState(() {});
        widget.saveChangesCallback();
      }
    }
  }
}
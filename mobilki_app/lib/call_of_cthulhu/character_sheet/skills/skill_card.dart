import 'package:flutter/material.dart';
import 'edit_skill_route_default.dart';
import 'edit_skill_route_user.dart';
import 'skill.dart';

class SkillCard extends StatefulWidget {
  const SkillCard({
    Key? key,
    required this.skill,
    required this.saveChangesCallback,
    required this.nameListGetter,
    required this.deleteSkillSetter,
    required this.repositionSkillSetter
  }) : super(key: key);

  final Skill skill;
  final VoidCallback saveChangesCallback;
  final ValueGetter<List<String>> nameListGetter;
  final ValueSetter<Skill> deleteSkillSetter;
  final ValueSetter<Skill> repositionSkillSetter;

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
    if(widget.skill.isUserCreated) { // user created skills allow for more editing
      String? result = await Navigator.push( // there are 5 possible values here
                                            // "changed" means that SkillCard has to be reloaded using setState
                                            // "reposition" means, that name of the skill has been changed, so it might need to repositioned in SkillsView
                                            // "delete" means, that user wants to delete the skill
                                            // "cancelled" or null means that user cancelled editing
        context,
        MaterialPageRoute(builder: (context) => EditSkillRouteUser(skill: widget.skill, nameList: widget.nameListGetter())),
      );
      if(result == null || result == "cancelled") {
        return;
      }
      if(result == "changed") {
        setState(() {});
        widget.saveChangesCallback();
      } else if(result == "reposition") {
        widget.repositionSkillSetter(widget.skill);
      } else if(result == "delete") {
        widget.deleteSkillSetter(widget.skill);
      }
    } else { // default skills can only have userLevel changes
      bool? result = await Navigator.push( // there are 3 possible values here
                                          // true means that changes have been done and setState is needed
                                          // false or null means that user cancelled editing
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
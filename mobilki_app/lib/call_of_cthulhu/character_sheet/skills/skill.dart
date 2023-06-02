class Skill {
  late String name;
  late int baseLevel;
  late int userLevel;
  late bool isUserCreated;

  Skill(this.name, this.baseLevel, this.userLevel, this.isUserCreated);

  Skill.fromString(String string) {
    final splitted = string.split(";");
    name = splitted[0];
    baseLevel = int.parse(splitted[1]);
    userLevel = int.parse(splitted[2]);
    isUserCreated = bool.parse(splitted[3]);
  }

  @override
  String toString() {
    return "$name;$baseLevel;$userLevel;$isUserCreated";
  }
}
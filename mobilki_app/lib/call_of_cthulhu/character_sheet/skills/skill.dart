class Skill {
  late String name;
  late int baseSuccessChance;
  int userLevel=0;
  late bool isUserCreated;
  late int overallSuccessChance;

  Skill(this.name, this.baseSuccessChance, this.isUserCreated) {
    overallSuccessChance = baseSuccessChance;
  }

  void updateUserLevel(int level) {
    if(level >= 0 && level + baseSuccessChance <= 99) {
      userLevel = level;
      overallSuccessChance = baseSuccessChance + userLevel;
    }
  }
}
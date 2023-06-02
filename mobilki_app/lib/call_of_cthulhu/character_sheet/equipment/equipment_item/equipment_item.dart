class EquipmentItem {
  late String name;
  late int count;
  double? price;

  EquipmentItem(this.name, this.count, this.price);

  EquipmentItem.fromString(String string) {
    final splitted = string.split(";");
    name = splitted[0];
    count = int.parse(splitted[1]);
    price = splitted[2] != "null" ? double.parse(splitted[2]) : null;
  }

  @override
  String toString() {
    return "$name;$count;$price";
  }
}
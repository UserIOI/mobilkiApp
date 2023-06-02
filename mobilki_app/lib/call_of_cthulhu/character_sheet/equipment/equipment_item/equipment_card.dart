import 'package:flutter/material.dart';
import 'equipment_item.dart';

class EquipmentCard extends StatefulWidget {
  final EquipmentItem item;
  const EquipmentCard({Key? key, required this.item}) : super(key: key);

  @override
  State<EquipmentCard> createState() => _EquipmentCardState();
}

class _EquipmentCardState extends State<EquipmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          title: Text(
              widget.item.name,
              style: const TextStyle(
                  fontSize: 18
              )
          ),
          trailing: Text(
              "x${widget.item.count}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
                fontWeight: FontWeight.normal,
              )
          ),
        ),
      ),
    );
  }
}

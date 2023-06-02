import 'package:flutter/material.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/equipment/equipment_enum.dart';
import 'equipment_item.dart';
import 'edit_item_route.dart';

class EquipmentCard extends StatefulWidget {
  const EquipmentCard({
    Key? key,
    required this.item,
    required this.type,
    required this.saveChangesCallback,
    required this.deleteItemSetter,
    required this.repositionItemSetter
  }) : super(key: key);

  final EquipmentItem item;
  final Equipment type;
  final VoidCallback saveChangesCallback;
  final ValueSetter<EquipmentItem> deleteItemSetter;
  final ValueSetter<EquipmentItem> repositionItemSetter;

  @override
  State<EquipmentCard> createState() => _EquipmentCardState();
}

class _EquipmentCardState extends State<EquipmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => openEditItemRoute(),
        child: ListTile(
          leading: IconButton(
            onPressed: () => widget.deleteItemSetter(widget.item),
            icon: const Icon(Icons.close, color: Colors.red),
          ),
          title: Text(
              widget.item.name,
              style: const TextStyle(
                  fontSize: 18
              )
          ),
          trailing: Text(
              "${widget.item.price!=null ? "${widget.item.price}\$  " : ""}x${widget.item.count}",
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

  void openEditItemRoute() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItemRoute(item: widget.item, type: widget.type)),
    );
    if(result == null || result == "cancelled") {
      return;
    }
    if(result == "changed") {
      setState(() {});
      widget.saveChangesCallback();
    } else if(result == "reposition") {
      widget.repositionItemSetter(widget.item);
    } else if(result == "delete") {
      widget.deleteItemSetter(widget.item);
    }
  }
}

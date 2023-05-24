import 'package:flutter/material.dart';

Future<int?> showChangeColumnCountDialog(BuildContext context, int columnCount) {
  return showDialog<int>(
      context: context,
      builder: (context) => ChangeColumnCountDialog(
        columnCount: columnCount,
      )
  );
}

class ChangeColumnCountDialog extends StatefulWidget {
  final int maxColumnCount = 5;
  final int columnCount;
  const ChangeColumnCountDialog({Key? key, required this.columnCount}) : super(key: key);

  @override
  State<ChangeColumnCountDialog> createState() => _ChangeColumnCountDialogState();
}

class _ChangeColumnCountDialogState extends State<ChangeColumnCountDialog> {
  int columnCount = 1;
  bool canBeLower = false;
  bool canBeHigher = true;

  @override
  void initState() {
    super.initState();
    columnCount = widget.columnCount;
    canBeLower = columnCount == 1 ? false : true;
    canBeHigher = columnCount == widget.maxColumnCount ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change column count"),
      content: Row(
        children: [
          IconButton(
              onPressed: canBeLower ? () {setState(() {
                columnCount -= 1;
                canBeLower = columnCount == 1 ? false : true;
                canBeHigher = columnCount == widget.maxColumnCount ? false : true;
              });} : null,
              icon: const Icon(Icons.chevron_left)),
          Text("$columnCount"),
          IconButton(
              onPressed: canBeHigher ? () {setState(() {
                columnCount += 1;
                canBeLower = columnCount == 1 ? false : true;
                canBeHigher = columnCount == widget.maxColumnCount ? false : true;
              });} : null,
              icon: const Icon(Icons.chevron_right)),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(columnCount),
          child: const Text("Save"),
        ),
      ],
    );
  }
}

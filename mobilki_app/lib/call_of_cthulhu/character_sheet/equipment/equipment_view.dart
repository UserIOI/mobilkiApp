import 'package:flutter/material.dart';

class EquipmentView extends StatefulWidget {
  final String playerName;
  const EquipmentView({Key? key, required this.playerName}) : super(key: key);

  @override
  State<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends State<EquipmentView> {
  String _selected = "weapons";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Money:"),
                const Text("600\$"),
                const Text("Spending:"),
                const Text("200\$"),
                const Text("/month"),
                IconButton(onPressed: () {}, icon: Icon(Icons.settings))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: _selected == "weapons" ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() { _selected = "weapons"; });},
                        child: const Text("Weapons"),
                      ),
                    )
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: _selected == "backpack" ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() { _selected = "backpack"; });},
                        child: const Text("Backpack"),
                      ),
                    )
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: _selected == "assets" ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() { _selected = "assets"; });},
                        child: const Text("Assets"),
                      ),
                    )
                ),
              ],
            ),
            const Placeholder(),
          ],
        ),
    );
  }
}

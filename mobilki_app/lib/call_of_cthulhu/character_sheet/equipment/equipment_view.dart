import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'equipment_enum.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/equipment/equipment_item/equipment_card.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/equipment/equipment_item/equipment_item.dart';
import 'package:mobilki_app/call_of_cthulhu/character_sheet/equipment/equipment_item/new_item_route.dart';
import 'package:mobilki_app/database/boxes.dart';

import '../../../database/player.dart';

class EquipmentView extends StatefulWidget {
  final String playerName;
  const EquipmentView({Key? key, required this.playerName}) : super(key: key);

  @override
  State<EquipmentView> createState() => _EquipmentViewState();
}

class _EquipmentViewState extends State<EquipmentView> {
  Equipment _selected = Equipment.weapons;
  List<EquipmentItem> _selectedList = [];
  bool _editMode = false;
  double _balance = 0;
  double _spending = 0;
  String _timePeriod = "week";
  String _dropdownValue = "week";
  List<EquipmentItem> _weaponList = [];
  List<EquipmentItem> _backpackItemList = [];
  List<EquipmentItem> _assetList = [];
  bool _playerLoaded = false;
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _spendingController = TextEditingController();

  @override
  void initState() {
    if(boxPlayers.containsKey(widget.playerName)) {
      _playerLoaded = true;
      Player player = boxPlayers.get(widget.playerName);
      _balance = player.characterWealth[0];
      _spending = player.characterWealth[1];
      _timePeriod = player.characterWealth[2];
      _dropdownValue = _timePeriod;
      _weaponList = player.weapons.map((item) => EquipmentItem.fromString(item)).toList();
      _backpackItemList = player.backpackItems.map((item) => EquipmentItem.fromString(item)).toList();
      _assetList = player.assets.map((item) => EquipmentItem.fromString(item)).toList();
      _selectedList = _weaponList;
    } else {
      _playerLoaded = false;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No player loaded"))));
    }
    super.initState();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _spendingController.dispose();
    super.dispose();
  }

  void saveWealthChanges() {
    if(boxPlayers.containsKey(widget.playerName)) {
      Player player = boxPlayers.get(widget.playerName);
      player.characterWealth = [_balance, _spending, _timePeriod];
      boxPlayers.put(widget.playerName, player);
    }
  }

  void saveSelectedListChanges() {
    if(boxPlayers.containsKey(widget.playerName)) {
      Player player = boxPlayers.get(widget.playerName);
      List<String> toSave = _selectedList.map((item) => item.toString()).toList();
      switch(_selected) {

        case Equipment.weapons:
          player.weapons = toSave;
          break;
        case Equipment.backpack:
          player.backpackItems = toSave;
          break;
        case Equipment.assets:
          player.assets = toSave;
          break;
      }
      boxPlayers.put(widget.playerName, player);
    }
  }

  void removeItem(EquipmentItem item) {
    setState(() {
      _selectedList.remove(item);
      saveSelectedListChanges();
    });
  }

  void repositionItem(EquipmentItem item) {
    int index = _selectedList.indexOf(item);
    setState(() {
      while(index > 0 && _selectedList[index].name.toLowerCase().compareTo(_selectedList[index - 1].name.toLowerCase()) < 0) {
        EquipmentItem temp = _selectedList[index - 1];
        _selectedList[index - 1] = _selectedList[index];
        _selectedList[index] = temp;
        index -= 1;
      }
      while(index < _selectedList.length - 1 && _selectedList[index].name.toLowerCase().compareTo(_selectedList[index + 1].name.toLowerCase()) > 0) {
        EquipmentItem temp = _selectedList[index + 1];
        _selectedList[index + 1] = _selectedList[index];
        _selectedList[index] = temp;
        index += 1;
      }
      saveSelectedListChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            buildCharacterBalanceRow(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                        style: _selected == Equipment.weapons ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() {
                          _selected = Equipment.weapons;
                          _selectedList = _weaponList;
                        });},
                        child: const Text("Weapons"),
                      ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton(
                        style: _selected == Equipment.backpack ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() {
                          _selected = Equipment.backpack;
                          _selectedList = _backpackItemList;
                        });},
                        child: const Text("Backpack"),
                      ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton(
                        style: _selected == Equipment.assets ? OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ) : null,
                        onPressed: () {setState(() {
                          _selected = Equipment.assets;
                          _selectedList = _assetList;
                        });},
                        child: const Text("Assets"),
                      ),
                  ),
                  IconButton(
                      onPressed: _playerLoaded ? () => addItem() : null,
                      icon: Icon(Icons.add, color: _playerLoaded ? Colors.green : Colors.grey),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: _selectedList.length,
                  itemBuilder: (context, index) {
                    return EquipmentCard(item: _selectedList[index],
                        type: _selected,
                        saveChangesCallback: saveSelectedListChanges,
                        deleteItemSetter: removeItem,
                        repositionItemSetter: repositionItem
                    );
                  }
              ),
            ),
          ],
        ),
    );
  }

  Widget buildCharacterBalanceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Balance:"),
        SizedBox(
          width: 60,
          child: _editMode ?  TextField(
            controller: _balanceController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ) : Text("$_balance\$"),
        ),
        const Text("-"),
        SizedBox(
          width: 60,
          child: _editMode ?  TextField(
            controller: _spendingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ) : Text("$_spending\$")
        ),
        const Text("/"),
        _editMode ? DropdownButton<String>(
          value: _dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          items: const [
            DropdownMenuItem(value: "day", child: Text("day")),
            DropdownMenuItem(value: "week", child: Text("week")),
            DropdownMenuItem(value: "fortnight", child: Text("fortnight")),
            DropdownMenuItem(value: "month", child: Text("month")),
            DropdownMenuItem(value: "quarter", child: Text("quarter")),
            DropdownMenuItem(value: "year", child: Text("year")),
          ],
          onChanged: (String? value) { setState(() { _dropdownValue = value!; }); },
        ) : Text(_timePeriod),
        _editMode ? Row(children: [
            IconButton(onPressed: () {setState(() {
              _editMode = false;
              _balance = double.parse(_balanceController.text);
              _spending = double.parse(_spendingController.text);
              _timePeriod = _dropdownValue;
              saveWealthChanges();
            });}, icon: const Icon(Icons.check, color: Colors.green)),
            IconButton(onPressed: () {setState(() { _editMode = false; });}, icon: const Icon(Icons.close , color: Colors.red)),
          ],
        ) : IconButton(onPressed: _playerLoaded? () {setState(() {
          _editMode = true;
          _balanceController.text = "$_balance";
          _spendingController.text = "$_spending";
          _dropdownValue = _timePeriod;
        });} : null, icon: const Icon(Icons.edit)),
      ],
    );
  }

  void addItem() async {
    EquipmentItem? item = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewItemRoute(type: _selected)),
    );
    if(item != null) {
      setState(() {
        int index;
        for(index = 0; index < _selectedList.length; index++) {
          if(_selectedList[index].name.toLowerCase().compareTo(item.name.toLowerCase()) > 0) {
            break;
          }
        }
        _selectedList.insert(index, item);
        saveSelectedListChanges();
      });
    }
  }
}

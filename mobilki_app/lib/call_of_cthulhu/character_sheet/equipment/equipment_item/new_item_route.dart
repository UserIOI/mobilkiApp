import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'equipment_item.dart';
import '../equipment_enum.dart';

class NewItemRoute extends StatefulWidget {
  final Equipment type;
  const NewItemRoute({Key? key, required this.type}) : super(key: key);

  @override
  State<NewItemRoute> createState() => _NewSkillRouteState();
}

class _NewSkillRouteState extends State<NewItemRoute> {
  int count = 0;
  double? price;
  String name = "";
  bool isNameValid = false;
  String? nameErrorText;
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController(text: "0");
  TextEditingController priceController = TextEditingController();

  void updateName() {
    setState(() {
      if(name == "") { // is name not empty?
        isNameValid = false;
        nameErrorText = "Name cannot be empty";
      } else if (name.contains(";")) { // does name NOT contain ";" ? (it is used to save skill to string format)
        isNameValid = false;
        nameErrorText = 'Name cannot contain ";" symbol';
      } else {
        isNameValid = true;
        nameErrorText = null;
      }
    });
  }

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {
        if(nameController.text != name) {
          name = nameController.text.trim();
          updateName();
        }
      });
    });
    countController.addListener(() {
      setState(() {
        count = countController.text.isEmpty ? 0 : int.parse(countController.text);
      });
    });
    priceController.addListener(() {
      setState(() {
        price = priceController.text.isEmpty ? null : double.parse(priceController.text);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    countController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == Equipment.weapons ? "Add new weapon" : widget.type == Equipment.backpack ? "Add new backpack item" : "Add new asset"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: InputDecoration(
                      errorText: nameErrorText,
                      hintText: "Pick a name",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Count:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 167,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: count > 0 ? () { countController.text = "${count - 1}"; } : null,
                              icon: const Icon(Icons.chevron_left)),
                          SizedBox(
                            width: 71,
                            child: TextField(
                              controller: countController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                              onPressed: () { countController.text = "${count + 1}"; },
                              icon: const Icon(Icons.chevron_right)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Price (optional):",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 167,
                      child: TextField(
                        controller: priceController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          suffix: Text("\$"),
                          border: OutlineInputBorder(),
                          hintText: "Not set"
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total value:",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 167,
                      child: Center(
                        child: Text(
                          price != null ? "${count * price!}" : "NaN",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () { Navigator.pop(context); },
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          disabledBackgroundColor: Colors.green.withOpacity(.8)
                      ),
                      onPressed: isNameValid ? () {
                        EquipmentItem item = EquipmentItem(name, count, price);
                        Navigator.pop(context, item);
                      } : null,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

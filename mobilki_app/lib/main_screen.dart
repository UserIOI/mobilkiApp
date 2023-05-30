import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  File? investigatorImage;

  Map<String, String?> investigatorAboutData = {
    "Name": "",
    "Occupation": "",
    "Age": "",
    "Residence": "",
    "PlaceOfBirth": "",
  };

  List<String> characteristic = [
    "STR",
    "CON",
    "DEX",
    "INT",
    "SIZ",
    "POW",
    "APP",
    "EDU",
  ];

  List<int> characteristicLevel = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) {
        return;
      }

      final imageTemp = File(image.path);

      setState(() {
        investigatorImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print("Can not pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //handles dialog  pop up
    final controller = TextEditingController();
    Future<String?> openDialog(String title) => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: (_) => Navigator.of(context).pop(controller.text),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.text = ""; //clear textfield xd but works
                  Navigator.of(context).pop(null);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(controller.text),
                  child: Text("Confirm")),
            ],
          ),
        );

    Future profilePictureSelectionDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Select investigator's picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Color.fromARGB(255, 134, 88, 46),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Icon(Icons.photo_size_select_actual_rounded),
                ),
                Divider(
                  height: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Color.fromARGB(255, 134, 88, 46),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Icon(Icons.camera_alt),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.text = ""; //clear textfield xd but works
                  Navigator.of(context).pop(null);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        );

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Card(
            margin: EdgeInsets.all(20),
            color: Color.fromARGB(255, 225, 216, 190),
            child: Column(
              children: [
                FittedBox(
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(30),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Investigator Data',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => profilePictureSelectionDialog(),
                            child: investigatorImage != null
                                ? Image.file(
                                    investigatorImage!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.photo_camera_front_outlined,
                                      size: 100,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                    label: "Name",
                                    data: investigatorAboutData["Name"]),
                                onTap: () async {
                                  final data = await openDialog("Name");
                                  setState(() {
                                    if (data != null)
                                      investigatorAboutData["Name"] = data;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                  label: "Occupation",
                                  data: investigatorAboutData["Occupation"],
                                ),
                                onTap: () async {
                                  final data = await openDialog("Occupation");
                                  setState(() {
                                    if (data != null)
                                      investigatorAboutData["Occupation"] =
                                          data;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                    label: "Age",
                                    data: investigatorAboutData["Age"]),
                                onTap: () async {
                                  final data = await openDialog("Age");
                                  setState(() {
                                    if (data != null)
                                      investigatorAboutData["Age"] = data;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                  label: "Residence",
                                  data: investigatorAboutData["Residence"],
                                ),
                                onTap: () async {
                                  final data = await openDialog("Residence");
                                  setState(() {
                                    if (data != null)
                                      investigatorAboutData["Residence"] = data;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: InvestigatorAboutInfo(
                                  label: "Place of birth",
                                  data: investigatorAboutData["PlaceOfBirth"],
                                ),
                                onTap: () async {
                                  final data =
                                      await openDialog("Place of birth");
                                  setState(() {
                                    if (data != null)
                                      investigatorAboutData["PlaceOfBirth"] =
                                          data;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Card(
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Characteristics",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 50,
                      left: 50,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 5 / 3,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: characteristic.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 11, bottom: 11),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 235, 162, 28)),
                          child: ListTile(
                            title: Text(
                              characteristic[index],
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              characteristicLevel[index].toString(),
                              style: TextStyle(fontSize: 24),
                            ),
                            onTap: () async {
                              final data =
                                  await openDialog(characteristic[index]);
                              if (data != null &&
                                  int.tryParse(data.toString()) != null) {
                                setState(() {
                                  characteristicLevel[index] =
                                      int.parse(data.toString());
                                });
                              } else {
                                controller.text = "";
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvestigatorAboutInfo extends StatelessWidget {
  final String label;
  final String? data;
  const InvestigatorAboutInfo({
    required this.label,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      margin: EdgeInsets.only(
        top: 5,
      ),
      child: Text(
        '$label: $data',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
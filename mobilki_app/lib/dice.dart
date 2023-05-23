// ignore_for_file: camel_case_types, must_be_immutable, no_logic_in_create_state

import 'dart:math';

import 'package:flutter/material.dart';

class dice extends StatefulWidget {
  final GlobalKey<diceWidget> _key = GlobalKey<diceWidget>();
  final x, y, nrKosci;
  String idk = '';

  dice({
    required Key? key,
    required this.x,
    required this.y,
    required this.nrKosci,
  }) : super(key: key);

  GlobalKey getKey() {
    return _key;
  }

  @override
  State<dice> createState() => diceWidget(x, y, nrKosci);
}

class diceWidget extends State<dice> {
  //** Zmienne przechowujace obrazy kosci */
  var images4 = ['d4/d4_1.png', 'd4/d4_2.png', 'd4/d4_3.png', 'd4/d4_4.png'];
  var images6 = [
    'd6/d6_1.png',
    'd6/d6_2.png',
    'd6/d6_3.png',
    'd6/d6_4.png',
    'd6/d6_5.png',
    'd6/d6_6.png'
  ];
  var images8 = [
    'd8/d8_1.png',
    'd8/d8_2.png',
    'd8/d8_3.png',
    'd8/d8_4.png',
    'd8/d8_5.png',
    'd8/d8_5.png',
    'd8/d8_5.png',
    'd8/d8_5.png'
  ];
  var images10 = [
    'd10/d10_1.png',
    'd10/d10_2.png',
    'd10/d10_3.png',
    'd10/d10_4.png',
    'd10/d10_5.png',
    'd10/d10_6.png',
    'd10/d10_7.png',
    'd10/d10_8.png',
    'd10/d10_9.png',
    'd10/d10_10.png'
  ];
  var images12 = [
    'd12/d12_1.png',
    'd12/d12_2.png',
    'd12/d12_3.png',
    'd12/d12_4.png',
    'd12/d12_5.png',
    'd12/d12_6.png',
    'd12/d12_7.png',
    'd12/d12_8.png',
    'd12/d12_9.png',
    'd12/d12_10.png',
    'd12/d12_11.png',
    'd12/d12_12.png'
  ];
  var images20 = [
    'd20/d20_1.png',
    'd20/d20_2.png',
    'd20/d20_3.png',
    'd20/d20_4.png',
    'd20/d20_5.png',
    'd20/d20_6.png',
    'd20/d20_7.png',
    'd20/d20_8.png',
    'd20/d20_9.png',
    'd20/d20_10.png',
    'd20/d20_11.png',
    'd20/d20_12.png',
    'd20/d20_13.png',
    'd20/d20_14.png',
    'd20/d20_15.png',
    'd20/d20_16.png',
    'd20/d20_17.png',
    'd20/d20_18.png',
    'd20/d20_19.png',
    'd20/d20_20.png'
  ];
  var images100 = [
    'd100/d100_00.png',
    'd100/d100_10.png',
    'd100/d100_20.png',
    'd100/d100_30.png',
    'd100/d100_40.png',
    'd100/d100_50.png',
    'd100/d100_60.png',
    'd100/d100_70.png',
    'd100/d100_80.png',
    'd100/d100_90.png',
  ];

  String baseForAssets = 'assets/images/';
  //** Mapa do przechowywania setow obrazow w zaleznosci od kosci */
  late Map imgSelector = {
    4: images4,
    6: images6,
    8: images8,
    10: images10,
    12: images12,
    20: images20,
    100: images100,
  };

  int x, y, nrKosci, i = 0;

  diceWidget(this.x, this.y, this.nrKosci);
  //late String idk = imgSelector[nrKosci][0];

  //** Random kosc */
  Random random = Random();
  late String idk =
      imgSelector[nrKosci][random.nextInt(imgSelector[nrKosci].length)];

  void throwing() async {
    Random random = Random();
    int a = random.nextInt(50) + 25;
    print(a);
    while (a > 0) {
      setState(() {
        idk = imgSelector[nrKosci][i];
        i++;
        if (i == imgSelector[nrKosci].length) i = 0;
      });
      await Future.delayed(const Duration(milliseconds: 60));
      a--;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      throwing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y.toDouble(),
      left: x.toDouble(),
      child: Image.asset(
        baseForAssets + idk,
        height: 70,
        width: 70,
      ),
    );
  }
}

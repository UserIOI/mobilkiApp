import 'package:flutter/material.dart';

class newnotedialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [TextField(), TextField()],
      ),
    );
  }
}

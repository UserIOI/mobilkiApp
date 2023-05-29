import 'package:flutter/material.dart';

class note {
  note(this.title, this.body, [this.isExpanded = false]);
  String title;
  String body;
  bool isExpanded;
}

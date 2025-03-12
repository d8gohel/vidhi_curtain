import 'package:flutter/material.dart';

class Styles {
  static final ButtonStyle buttonstyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    // shape: LinearBorder(),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

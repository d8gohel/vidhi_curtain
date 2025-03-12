import 'package:flutter/material.dart';
// import 'package:gi_ecommerce/modules/colors.dart';

class Gradientbutton extends StatefulWidget {
  final dynamic text;

  final Function fun;

  const Gradientbutton({super.key, required this.text, required this.fun});

  @override
  State<Gradientbutton> createState() => _GradientbuttonState();
}

class _GradientbuttonState extends State<Gradientbutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(41, 50, 75, 1),
            Color.fromRGBO(41, 50, 75, 0.75)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          widget.fun();
        },
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

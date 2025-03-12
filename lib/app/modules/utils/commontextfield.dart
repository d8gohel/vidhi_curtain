import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String label;
  // final String? value;
  final IconData iconData;
  final TextInputType? textInputType;
  TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onchange;

  CommonTextField({
    super.key,
    required this.label,
    // required this.value,
    required this.iconData,
    required this.controller,
    this.textInputType,
    this.validator,
    this.onchange,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
          // initialValue: value,
          decoration: InputDecoration(
            label: Text(label),
            border: OutlineInputBorder(),
            prefixIcon: Icon(iconData),
          ),
          validator: validator,
          onChanged: onchange,
        ),
        SizedBox(height: 5),
      ],
    );
  }
}

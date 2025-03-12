import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vidhiadmin/app/data/color.dart';
import 'package:vidhiadmin/app/modules/Auth/controllers/auth_controller.dart';
import 'package:vidhiadmin/app/modules/utils/gradientbutton.dart';

class ForgotpasswordView extends GetView {
  ForgotpasswordView({super.key});
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController mail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotpasswordView'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: color.themecolor,
                    controller: mail,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      labelStyle: TextStyle(color: color.themecolor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ), // Set circular border radius here
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ), // Default border color (you can change it)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Circular border radius for enabled state
                        borderSide: BorderSide(
                          color: color.themecolor,
                          width: 1.0,
                        ), // Change border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Circular border radius for focused state
                        borderSide: BorderSide(
                          color: color.themecolor,
                          width: 2.0,
                        ), // Change border color when focused
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Gradientbutton(
                text: "Send Mail",
                fun: () {
                  if (formkey.currentState?.validate() ?? false) {
                    controller.forgotPassword(
                      email: mail.text,
                      context: context,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

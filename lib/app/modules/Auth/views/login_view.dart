import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/data/color.dart';
import 'package:vidhiadmin/app/data/images.dart';
import 'package:vidhiadmin/app/modules/Auth/controllers/auth_controller.dart';
import 'package:vidhiadmin/app/modules/Auth/views/forgotpassword_view.dart';
import 'package:vidhiadmin/app/modules/utils/gradientbutton.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool check = true;
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController mailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.themecolor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 5,
              backgroundColor: Colors.white,
              child: Image.asset(
                coreimages.icon,
                height: MediaQuery.of(context).size.width / 5,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '👋 Welcome , Shopaholic! 🛒 Your next favorite find is just a click away! ',
                        ),
                        TextSpan(
                          text: 'Login now.',
                          style: TextStyle(color: color.themecolor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        // Email field with validator
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: color.themecolor,
                          controller: mailcontroller,
                          decoration: InputDecoration(
                            label: Text('Email'),

                            labelStyle: TextStyle(color: color.themecolor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: color.themecolor,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: color.themecolor,
                                width: 2.0,
                              ),
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
                        SizedBox(height: 10),
                        // Password field with validator
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: color.themecolor,
                          controller: passwordcontroller,
                          obscureText: check,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  check = !check;
                                  log(check.toString());
                                });
                              },
                              icon: Icon(
                                !check
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                              ),
                            ),
                            label: Text('Password'),
                            labelStyle: TextStyle(color: color.themecolor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: color.themecolor,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: color.themecolor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Gradientbutton(
                    text: 'Login',
                    fun: () {
                      if (formkey.currentState?.validate() ?? false) {
                        controller.loginWithEmailPassword(
                          email: mailcontroller.text,
                          password: passwordcontroller.text,
                          context: context,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => ForgotpasswordView());
                        },
                        child: Text(
                          'click here',
                          style: TextStyle(
                            color: color.themecolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

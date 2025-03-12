import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vidhiadmin/app/data/images.dart';
import 'package:vidhiadmin/app/modules/Auth/views/login_view.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      // Navigate to the next screen (replace `NextPage` with your desired page)
      Get.off(() => LoginView());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset(coreimages.icon)),
    );
  }
}

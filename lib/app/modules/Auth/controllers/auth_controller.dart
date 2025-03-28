import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vidhiadmin/app/modules/home/views/home_view.dart';

class AuthController extends GetxController {
  final count = 0.obs;
  bool check = true;
  bool password = true;
  bool cnfpassword = true;

  final SupabaseClient supabase = Supabase.instance.client;

  // Centralized error handling method

  // Login method with email and password
  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Attempt to log in with Supabase Authentication
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      Logger(printer: PrettyPrinter()).i(response.user);

      // Dismiss the loading dialog once login is successful
      Get.back();
      Get.off(() => HomeView());
    } catch (e) {
      Get.back();

      // Show the error message
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> sigunup(mail, password, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Send password reset email with Supabase Authentication
      await supabase.auth.signUp(email: mail, password: password);
      Get.back();
      Get.snackbar("success", "Signup successful");
    } catch (e) {
      Get.back();
      Get.snackbar("not success", e.toString());
    }
  }

  // Forgot password method
  Future<void> forgotPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Send password reset email with Supabase Authentication
      await supabase.auth.resetPasswordForEmail(email);

      Get.back();
      Get.snackbar(
        "Forgot password",
        "Password reset link is sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.back();

      // Show the error message
      Get.snackbar(
        'Password Reset Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void increment() => count.value++;
}

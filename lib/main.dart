import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRraHNuc2FnaXl4aXp4YWFqeWluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEyNjIwNjAsImV4cCI6MjA1NjgzODA2MH0.lf8T9GGHMtigQzaiX54TXm_SmGzcWaJxsJ_V6LMtF1Y",
    url: 'https://tkhsnsagiyxizxaajyin.supabase.co',
  );
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    await windowManager.setResizable(false);

    await windowManager.center();
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presentation_controller.dart';

class PresentationView extends GetView<PresentationController> {
  const PresentationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PresentationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PresentationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

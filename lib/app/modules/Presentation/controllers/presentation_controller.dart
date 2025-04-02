import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/presentation_view.dart';

class AppController extends GetxController {
  late CameraController cameraController;
  late Future<void> initializeControllerFuture;
  final RxInt index = 0.obs;
  XFile? image;
  final double boxHeight = 250.0;
  final double boxWidth = 300.0;
  late PostgrestList response;
  List<String> images=[];

  @override
  void onInit() {
    super.onInit();
    initializeControllerFuture = initializeCamera(); // Assign immediately

  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(CameraDescription(name: "", lensDirection: CameraLensDirection.back , sensorOrientation: 0), ResolutionPreset.high);
      await cameraController.initialize();
      update();
      final supabase = Supabase.instance.client;
       response = await supabase
          .from("products")
          .select();
         
          
    } else {
      Get.snackbar("Camera Error", "No camera found!");
    }
  }

  Future<void> captureAndNavigate() async {
    await initializeControllerFuture;
    image = await cameraController.takePicture();
    update();
    Get.to(() => DisplayImageScreen());
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
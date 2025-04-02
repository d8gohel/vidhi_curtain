import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vidhiadmin/app/modules/Presentation/controllers/presentation_controller.dart';

class CameraScreen extends StatelessWidget {
  final AppController cameraController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<void>(
          future: cameraController.initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  // Rotated camera preview
                  RotatedBox(
                    quarterTurns: 1,
                    child: SizedBox(
                      width:
                          MediaQuery.sizeOf(
                            context,
                          ).height, // Use height as width
                      child: CameraPreview(cameraController.cameraController),
                    ),
                  ),

                  // Backdrop blur effect

                  // Resizable Camera Preview Box
                  RotatedBox(
                    quarterTurns: 1,
                    child: Center(
                      child: AnimatedContainer(
                        width: cameraController.boxWidth,
                        height: cameraController. boxHeight,
                        // color: Colors.blue,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.green),
                        ),
                        duration: Duration(seconds: 1),
                        child: GestureDetector(
                          // child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                "Create in Vertical position",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: cameraController.captureAndNavigate,
                          child: Icon(
                            Icons.file_upload_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Capture Button
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 205),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        child: TextButton(
                          onPressed: cameraController.captureAndNavigate,
                          child: Text(
                            "Capture Image",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

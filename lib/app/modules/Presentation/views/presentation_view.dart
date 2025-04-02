import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhiadmin/app/data/color.dart';
import 'package:vidhiadmin/app/data/images.dart';
import 'package:vidhiadmin/app/modules/Presentation/controllers/presentation_controller.dart';

class DisplayImageScreen extends StatelessWidget {
  const DisplayImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();
    var curtains = coreimages.imgarr;

    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(curtains[controller.index.value]))),
      body: PageView.builder(
        itemCount: controller.response.length,
        onPageChanged: (value) => controller.index.value = value,
        itemBuilder: (context, index) {
          return GestureDetector(
            // onTap: () => Get.to(() => DetailsView(index: index)),
            child: Card(
              elevation: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Center(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(File(controller.image!.path), fit: BoxFit.cover),
                    ),
                    BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(color: Colors.black.withOpacity(0)),
                    ),
                    Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Image.network(
                          controller.response[index]["image_url"],
                          height: controller.boxHeight,
                          width: controller.boxWidth,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.themecolor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Text(
                                "Brand: ${controller.response[index]["brand_name"]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sanchez(fontSize: 25, color: Colors.white ),
                              ),
                              Text(
                                "Cloth: ${controller.response[index]["brand_name"]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sanchez(fontSize: 22, color: Colors.white),
                              ),
                              Text(
                               "Price: ${controller.response[index]["price"]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sanchez(fontSize: 20, color: Colors.white),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

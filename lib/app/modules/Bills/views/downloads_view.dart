import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:vidhiadmin/app/modules/Bills/controllers/bills_controller.dart';
// import 'cache_controller.dart'; // Import the controller

class CacheFilesPage extends StatelessWidget {
  const CacheFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of the controller
    final BillsController cacheController = Get.put(BillsController());

    return Scaffold(
      appBar: AppBar(title: Text('Cache Files')),
      body: Obx(() {
        // Using Obx to reactively rebuild when 'files' changes
        if (cacheController.files.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Show loading if files are still being fetched
        }

        return ListView.builder(
          itemCount: cacheController.files.length,
          itemBuilder: (context, index) {
            FileSystemEntity file = cacheController.files[index];
           List<String> parts = file.path.split('/');
  
  // Get the last element, which is the file name
  String fileName = parts.last;
  
  print(fileName);

            Logger().i(file.path);
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(fileName, style: GoogleFonts.sanchez(fontSize: 16)),
                // subtitle: Text(file.path),
                leading: Icon(Icons.picture_as_pdf),
                onTap: () async {
                  await OpenFilex.open(file.path);
                  print("object");
                },
              ),
            );
          },
        );
      }),
    );
  }
}

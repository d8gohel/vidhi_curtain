import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/modules/utils/commontextfield.dart';
import '../controllers/window_controller.dart';
import 'package:vidhiadmin/app/data/windowmodel.dart';

void showWindowBottomSheet({WindowModel? window, required int userId}) {
  final WindowController windowController = Get.find();
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController(
    text: window?.name ?? '',
  );
  final TextEditingController heightController = TextEditingController(
    text: window?.height.toString() ?? '',
  );
  final TextEditingController widthController = TextEditingController(
    text: window?.width.toString() ?? '',
  );

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                window == null ? "Add Window" : "Edit Window",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              CommonTextField(
                controller: nameController,
                label: "Window Name",
                iconData: Icons.window,
                validator:
                    (value) => value!.isEmpty ? "Enter window name" : null,
              ),

              CommonTextField(
                controller: heightController,
                label: "Height",
                iconData: Icons.height,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Enter height";
                  if (double.tryParse(value) == null) {
                    return "Enter valid height";
                  }
                  return null;
                },
              ),

              CommonTextField(
                controller: widthController,
                label: "Width",
                iconData: Icons.square_foot,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Enter width";
                  if (double.tryParse(value) == null) {
                    return "Enter valid width";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (window == null) {
                        windowController.addWindow(
                          WindowModel(
                            id: 0, // Supabase will auto-generate this
                            userId: userId,
                            name: nameController.text,
                            height: double.parse(heightController.text),
                            width: double.parse(widthController.text),
                          ),
                        );
                      } else {
                        windowController.updateWindow(
                          window.id,
                          WindowModel(
                            id: window.id,
                            userId: window.userId,
                            name: nameController.text,
                            height: double.parse(heightController.text),
                            width: double.parse(widthController.text),
                          ),
                        );
                      }
                      Get.back();
                    }
                  },
                  child: Text(window == null ? "Add Window" : "Update Window"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

// Reusable text field widget

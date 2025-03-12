import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/window_controller.dart';

import 'bottomsheert.dart';

class WindowListScreen extends StatelessWidget {
  final int userId;
  WindowListScreen({super.key, required this.userId});

  final WindowController windowController = Get.put(WindowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Windows')),
      body: Obx(() {
        var userWindows =
            windowController.windows.where((w) => w.userId == userId).toList();
        if (userWindows.isEmpty) {
          return Center(child: Text('No Windows Found for this User'));
        }
        return ListView.builder(
          itemCount: userWindows.length,
          itemBuilder: (context, index) {
            final window = userWindows[index];
            return ListTile(
              title: Text(window.name),
              subtitle: Text('Size: ${window.height} x ${window.width}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed:
                        () => showWindowBottomSheet(
                          window: window,
                          userId: userId,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => windowController.deleteWindow(window.id),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showWindowBottomSheet(userId: userId),
      ),
    );
  }
}

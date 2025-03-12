import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/modules/User/views/bottomsheet.dart';
import '../../window/views/window_view.dart';
import '../controllers/user_controller.dart';

class UserListScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Obx(() {
        if (userController.users.isEmpty) {
          return Center(child: Text('No Users Found'));
        }
        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return ListTile(
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => WindowListScreen(userId: user.id!));
                    },
                    icon: Icon(Icons.window_outlined),
                    // child: Text("Windows"),
                  ),
                  SizedBox(width: 8),
                  Text("asdkfl"),

                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed:
                        () => showUserBottomSheet(user: user, context: context),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => userController.deleteUser(user.id!),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showUserBottomSheet(context: context),
      ),
    );
  }
}

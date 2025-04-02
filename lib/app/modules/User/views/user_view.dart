import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/modules/User/views/bottomsheet.dart';

import 'package:vidhiadmin/app/modules/utils/styles.dart';
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
        if (userController.loading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (userController.users.isEmpty) {
          return Center(child: Text('No Users Found'));
        }
        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final user = userController.users[index];
            return Card(
              color: Colors.white,
              elevation: 5,
              child: ListTile(
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

                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed:
                          () =>
                              showUserBottomSheet(user: user, context: context),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          radius: 0,

                          title: 'Confirm Action',
                          middleText: 'Are you sure you want to Delete?',
                          onCancel: () {
                            Get.snackbar(
                              'Cancelled',
                              'You cancelled the action',
                            );
                          },
                          onConfirm: () {
                            Get.snackbar(
                              'Confirmed',
                              'You confirmed the action',
                            );
                          },
                          confirm: ElevatedButton(
                            style: Styles.buttonstyle,
                            onPressed: () {
                              userController.deleteUser(user.id!);
                              Get.back();
                            },
                            child: Text('Yes'),
                          ),
                          cancel: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('No'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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

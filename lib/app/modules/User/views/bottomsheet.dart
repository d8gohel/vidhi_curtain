import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/data/usermodel.dart';
import 'package:vidhiadmin/app/modules/utils/commontextfield.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';
import '../controllers/user_controller.dart';

void showUserBottomSheet({required BuildContext context, UserModel? user}) {
  final userController = UserController();
  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController(
    text: user?.firstName ?? '',
  );
  final TextEditingController lastNameController = TextEditingController(
    text: user?.lastName ?? '',
  );
  final TextEditingController emailController = TextEditingController(
    text: user?.email ?? '',
  );
  final TextEditingController phoneController = TextEditingController(
    text: user?.phoneNumber ?? '',
  );
  final TextEditingController addressController = TextEditingController(
    text: user?.address ?? '',
  );
  final TextEditingController cityController = TextEditingController(
    text: user?.city ?? '',
  );
  final TextEditingController zipController = TextEditingController(
    text: user?.zipCode ?? '',
  );
  showModalBottomSheet(
    context: context,
    shape: BeveledRectangleBorder(),
    isScrollControlled: true, // Ensures the sheet adjusts to the keyboard
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom:
              MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user == null ? "Add User" : "Edit User",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                CommonTextField(
                  controller: firstNameController,
                  label: "First Name",
                  iconData: Icons.person,
                  validator:
                      (value) => value!.isEmpty ? "Enter first name" : null,
                ),
                CommonTextField(
                  controller: lastNameController,
                  label: "Last Name",
                  iconData: Icons.person_outline,
                  validator:
                      (value) => value!.isEmpty ? "Enter last name" : null,
                ),
                CommonTextField(
                  controller: emailController,
                  label: "Email",
                  iconData: Icons.email,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return "Enter email";
                    if (!RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                CommonTextField(
                  controller: phoneController,
                  label: "Phone Number",
                  iconData: Icons.phone,
                  textInputType: TextInputType.phone,
                  validator:
                      (value) =>
                          value!.isNotEmpty && value.isNumericOnly
                              ? null
                              : "Enter phone number",
                ),
                CommonTextField(
                  controller: addressController,
                  label: "Address",
                  iconData: Icons.home,
                  validator: (value) => value!.isEmpty ? "Enter address" : null,
                ),
                CommonTextField(
                  controller: cityController,
                  label: "City",
                  iconData: Icons.location_city,
                  validator: (value) => value!.isEmpty ? "Enter city" : null,
                ),
                CommonTextField(
                  controller: zipController,
                  label: "Zip Code",
                  iconData: Icons.pin_drop,
                  textInputType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? "Enter zip code" : null,
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    style: Styles.buttonstyle,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (user == null) {
                          userController.addUser(
                            UserModel(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                              address: addressController.text,
                              city: cityController.text,
                              zipCode: zipController.text,
                            ),
                          );
                        } else {
                          userController.updateUser(
                            user.id!,
                            UserModel(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                              address: addressController.text,
                              city: cityController.text,
                              zipCode: zipController.text,
                            ),
                          );
                        }
                        Navigator.pop(context); // Close the bottom sheet
                      }
                    },
                    child: Text(user == null ? "Add User" : "Update User"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

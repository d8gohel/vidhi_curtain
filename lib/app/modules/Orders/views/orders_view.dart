import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/data/windowmodel.dart';
import 'package:vidhiadmin/app/modules/Orders/controllers/orders_controller.dart';
import 'package:vidhiadmin/app/modules/utils/commontextfield.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

class OrdersView extends StatelessWidget {
  final OrdersController controller = Get.put(OrdersController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController numbercontroller = TextEditingController();
  final TextEditingController heightcontroller = TextEditingController();
  final TextEditingController widthcontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(title: Text('Vidhi Curtain')),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: screenHeight - keyboardHeight - 100,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TypeAheadField<String>(
                    controller: _nameController,
                    suggestionsCallback: (pattern) async {
                      // Filter users based on first name or last name containing the pattern
                      var filteredData =
                          controller.users
                              .where(
                                (user) =>
                                    user.firstName.toLowerCase().contains(
                                      pattern.toLowerCase(),
                                    ) ||
                                    user.lastName.toLowerCase().contains(
                                      pattern.toLowerCase(),
                                    ),
                              )
                              .map(
                                (user) => "${user.firstName} ${user.lastName}",
                              )
                              .toList();

                      // Update the username text field as the user types
                      controller.username.value = _nameController.text;
                      print(filteredData);

                      return filteredData;
                    },
                    itemBuilder: (context, String suggestion) {
                      // Build list item for each suggestion
                      return ListTile(title: Text(suggestion));
                    },
                    onSelected: (String value) {
                      // Find the selected user by matching first or last name
                      var selectedUser = controller.users.firstWhere(
                        (user) => "${user.firstName} ${user.lastName}" == value,
                      );

                      // Update fields only if a valid user is found
                      controller.username.value = value;
                      _nameController.text = value;
                      controller.phoneNumber.value = selectedUser.phoneNumber;
                      numbercontroller.text = selectedUser.phoneNumber;

                      // Filter windows by selected user ID
                      controller.windows =
                          controller.windows
                              .where(
                                (window) => window.userId == selectedUser.id,
                              )
                              .toList();

                      // Force an app update to refresh the UI
                      Get.forceAppUpdate();
                    },
                  ),
                  SizedBox(height: 5),
                  CommonTextField(
                    controller: numbercontroller,
                    onchange: (value) {
                      controller.phoneNumber.value = value!;
                    },
                    textInputType: TextInputType.number,
                    label: 'Phone Number',
                    iconData: Icons.phone,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "Phone number cannot be empty";
                      }
                      if (p0.length < 10) {
                        return "Phone number must be at least 10 digits";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),

                  DropdownButtonFormField<WindowModel>(
                    decoration: InputDecoration(
                      label: Text("Window Type"),
                      prefixIcon: Icon(Icons.window),
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedWindow,
                    onChanged: (WindowModel? selectedWindow) {
                      controller.selectedWindow = selectedWindow;
                      heightcontroller.text =
                          controller.selectedWindow!.height.toString();
                      widthcontroller.text =
                          controller.selectedWindow!.width.toString();
                      controller.height.value = double.parse(
                        heightcontroller.text,
                      );
                      controller.width.value = double.parse(
                        widthcontroller.text,
                      );
                      Get.forceAppUpdate();
                    },

                    items:
                        controller.windows.map<DropdownMenuItem<WindowModel>>((
                          WindowModel window,
                        ) {
                          return DropdownMenuItem<WindowModel>(
                            value: window,
                            child: Text(window.name),
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 5),

                  CommonTextField(
                    label: 'Height',
                    iconData: Icons.height,
                    onchange: (value) {
                      controller.height.value = double.tryParse(value!) ?? 0.0;
                    },
                    textInputType: TextInputType.number,
                    controller: heightcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Height cannot be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid number for height";
                      }
                      return null;
                    },
                  ),

                  CommonTextField(
                    label: 'Width',
                    iconData: Icons.width_full_outlined,
                    onchange: (value) {
                      controller.width.value = double.tryParse(value!) ?? 0.0;
                    },
                    textInputType: TextInputType.number,
                    controller: widthcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Width cannot be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid number for width";
                      }
                      return null;
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: Text("Type"),
                      prefixIcon: Icon(Icons.wb_incandescent_outlined),
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedOption.value,
                    onChanged: (value) {
                      controller.selectedOption.value = value ?? '120';
                      Get.forceAppUpdate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a type";
                      }
                      return null;
                    },
                    items: [
                      DropdownMenuItem(
                        value: '120',
                        child: Text('Arabian Curtain'),
                      ),
                      DropdownMenuItem(
                        value: '210',
                        child: Text('Ring Curtain'),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  CommonTextField(
                    label: 'Cloth Price',
                    iconData: Icons.currency_rupee,
                    onchange: (value) {
                      controller.price.value = double.tryParse(value!) ?? 0.0;
                    },
                    textInputType: TextInputType.number,
                    controller: pricecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Cloth price cannot be empty";
                      }
                      if (double.tryParse(value) == null) {
                        return "Please enter a valid price";
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text("Is pipe fitted"),
                    leading: Checkbox(
                      value: controller.ispipefitted,
                      onChanged: (value) {
                        controller.ispipefitted = value!;
                        Get.forceAppUpdate();
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.count();
                          } else {
                            Get.snackbar("Error", "all message are required");
                          }
                        },
                        style: Styles.buttonstyle,
                        child: Text('Count'),
                      ),
                      if (controller.tableData.isNotEmpty)
                        Row(
                          children: [
                            SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: () {
                                controller.savedata();
                              },
                              style: Styles.buttonstyle,
                              child: Text("Save"),
                            ),
                            SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: () {
                                // controller.savedata();
                                _nameController.text = "";
                                controller.selectedOption.value = "";
                                heightcontroller.text = "";
                                widthcontroller.text = "";
                                pricecontroller.text = "";
                              },
                              style: Styles.buttonstyle,
                              child: Text("Clear Fields"),
                            ),
                          ],
                        ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Obx(
                    () =>
                        controller.tableData.isEmpty
                            ? Center(
                              child: Text("Click on count to get Estimation"),
                            )
                            : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: DataTable(
                                    columns: [
                                      DataColumn(label: Text('Cost Type')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Rate')),
                                      DataColumn(label: Text('Total')),
                                    ],
                                    rows:
                                        controller.tableData
                                            .map(
                                              (data) => DataRow(
                                                cells:
                                                    data
                                                        .map(
                                                          (e) => DataCell(
                                                            Text(e.toString()),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                            ),
                  ),
                  SizedBox(height: 20), // Add some space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

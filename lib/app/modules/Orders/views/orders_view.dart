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

  OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    print(keyboardHeight);
    return Scaffold(
      appBar: AppBar(title: Text('Vidhi Curtain')),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: screenHeight - keyboardHeight - 100,

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TypeAheadField<String>(
                  controller: _nameController,
                  suggestionsCallback: (pattern) async {
                    var filteredData =
                        controller.users
                            .where(
                              (user) => user.firstName.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .map((user) => user.firstName)
                            .toList();
                    return filteredData;
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSelected: (String value) {
                    var selectedUser = controller.users.firstWhere(
                      (user) => user.firstName == value,
                    );
                    controller.username.value = value;
                    _nameController.text = value;
                    controller.phoneNumber.value = selectedUser.phoneNumber;
                    numbercontroller.text = selectedUser.phoneNumber;
                    controller.windows =
                        controller.windows
                            .where((window) => window.userId == selectedUser.id)
                            .toList();
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
                    controller.width.value = double.parse(widthcontroller.text);
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
                ),
                CommonTextField(
                  label: 'Width',
                  iconData: Icons.width_full_outlined,
                  onchange: (value) {
                    controller.width.value = double.tryParse(value!) ?? 0.0;
                  },
                  textInputType: TextInputType.number,
                  controller: widthcontroller,
                ),
                SizedBox(height: 5),
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
                  items: [
                    DropdownMenuItem(
                      value: '120',
                      child: Text('Arabian Curtain'),
                    ),
                    DropdownMenuItem(value: '210', child: Text('Ring Curtain')),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Cloth Price',
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    controller.price.value = double.tryParse(value) ?? 0.0;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: controller.count,
                  style: Styles.buttonstyle,
                  child: Text('Count'),
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
                                decoration: BoxDecoration(border: Border.all()),
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
    );
  }
}

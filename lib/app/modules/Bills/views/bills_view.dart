import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhiadmin/app/data/color.dart';
import 'package:vidhiadmin/app/modules/Bills/views/details_view.dart';
import 'package:vidhiadmin/app/modules/Bills/views/downloads_view.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';
import '../controllers/bills_controller.dart';

class BillsView extends GetView<BillsController> {
  BillsView({super.key});
  @override
  final BillsController controller = Get.put(BillsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BillsView'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: Styles.buttonstyle,
              onPressed: () {
                Get.to(() => CacheFilesPage());
              },
              icon: Icon(Icons.download_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () =>
            controller.checklist.any((element) => element == true)
                ? Card(
                  color: Colors.white,
                  elevation: 15,
                  child: SizedBox(
                    height: 50,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ), // default style
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Total : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // "Total :"
                                  TextSpan(
                                    text:
                                        controller.total.value
                                            .toString(), // The dynamic value from controller
                                    style: GoogleFonts.sanchez(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.genratepdf();
                            },
                            style: Styles.buttonstyle,
                            child: Text(
                              "Download",
                              style: GoogleFonts.sanchez(fontSize: 15),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     controller.genratepdf();
                          //   },
                          //   style: Styles.buttonstyle,
                          //   child: Text(
                          //     "Download Bill",
                          //     style: GoogleFonts.sanchez(fontSize: 15),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders available.'));
          } else {
            return Obx(() {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data![index];
                  return Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      leading: Obx(
                        () => Checkbox(
                          activeColor: color.themecolor,
                          value: controller.checklist[index],
                          onChanged: (value) {
                            controller.toggleCheckListItem(index);
                          },
                        ),
                      ),
                      onTap: () {
                        Get.to(() => DetailsView(data: order));
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order["name"]),
                          Text(order["total_cost"].toString()),
                        ],
                      ),
                      subtitle: Text(order["type"]),
                    ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vidhiadmin/app/modules/Auth/views/auth_view.dart';import 'package:vidhiadmin/app/modules/Bills/views/bills_view.dart';
import 'package:vidhiadmin/app/modules/Orders/views/orders_view.dart';
import 'package:vidhiadmin/app/modules/Presentation/views/display_image.dart';
import 'package:vidhiadmin/app/modules/Presentation/views/presentation_view.dart';
import 'package:vidhiadmin/app/modules/Products/views/products_view.dart';
import 'package:vidhiadmin/app/modules/User/views/user_view.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final CarouselController controller = CarouselController(initialItem: 1);

    // Track the current index of the carousel

    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                radius: 0,

                title: 'Confirm Action',
                middleText: 'Are you sure you want to Logout?',
                onCancel: () {
                  Get.snackbar('Cancelled', 'You cancelled the action');
                },
                onConfirm: () {
                  Get.snackbar('Confirmed', 'You confirmed the action');
                },
                confirm: ElevatedButton(
                  style: Styles.buttonstyle,
                  onPressed: () async {
                    final SupabaseClient supabase = Supabase.instance.client;
                    await supabase.auth.signOut();
                    Get.back();
                    Get.off(() => AuthView());
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
            icon: Icon(Icons.logout, color: Colors.red, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardWidget(
              name: "User",
              iconData: Icons.person_sharp,
              color: Colors.grey,
              ontap: () {
                Get.to(() => UserListScreen());
              },
            ),
            CardWidget(
              name: "Product",
              iconData: Icons.curtains_rounded,
              color: Colors.red,
              ontap: () {
                Get.to(() => ProductsView());
              },
            ),
            CardWidget(
              name: "Estimation",
              iconData: Icons.list_alt,
              color: Colors.blue,
              ontap: () {
                Get.to(() => OrdersView());
              },
            ),
            CardWidget(
              name: "Bills",
              iconData: Icons.edit_document,
              color: Colors.green,
              ontap: () {
                Get.to(() => BillsView());
              },
            ),
            CardWidget(
              name: "Show Demo",
              iconData: Icons.desktop_mac_outlined,
              color: Colors.yellow,
              ontap: () {
                Get.to(() => CameraScreen());
              },
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 4,
              child: CarouselView.weighted(
                controller: controller,

                itemSnapping: true,
                flexWeights: const <int>[1, 10, 1],
                children: List.generate(
                  10,
                  (index) => Image.network(
                    "https://www.alexbirkett.com/wp-content/uploads/2022/11/iamalexbirkett_jacked_aliens_wandering_through_lord_of_the_ring_0bee4dd7-c4a1-4f73-9b1b-f407f052054f.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String name;
  final IconData iconData;
  final Color color;
  final Function ontap;
  const CardWidget({
    super.key,
    required this.name,
    required this.iconData,
    required this.color,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        height: 80,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ), // Optional: add rounded corners
          color: Colors.white, // Optional: set the background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300, // effect
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(iconData, size: 30, color: color),
            SizedBox(width: 15),
            Text(
              name,
              style: GoogleFonts.sanchez(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

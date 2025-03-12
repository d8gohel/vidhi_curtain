import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhiadmin/app/modules/Bills/views/bills_view.dart';
import 'package:vidhiadmin/app/modules/Orders/views/orders_view.dart';
import 'package:vidhiadmin/app/modules/Presentation/views/presentation_view.dart';
import 'package:vidhiadmin/app/modules/Products/views/products_view.dart';
import 'package:vidhiadmin/app/modules/User/views/user_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final CarouselController controller = CarouselController(initialItem: 1);

    // Track the current index of the carousel

    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: Column(
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
              Get.to(() => PresentationView());
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

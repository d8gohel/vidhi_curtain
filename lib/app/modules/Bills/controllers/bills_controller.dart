// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/widgets.dart' as pw;

class BillsController extends GetxController {
  final supabase = Supabase.instance.client;
  var orders = <Map<String, dynamic>>[].obs;
  var checklist = <bool>[].obs; // Make checklist reactive
  final logger = Logger();
  List billlist = [];
  final RxDouble total = 0.0.obs;
  RxList<List<dynamic>> tableData = <List<dynamic>>[].obs;
  List<Map<String, dynamic>> modifiedData = [];

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  double sum(List l, String arg) {
    double sum = 0;
    for (var element in l) {
      sum += element[arg];
    }
    return sum;
  }

  double finalsum(String rate, String qty) {
    double tot = 0;
    for (var element in billlist) {
      tot += (element[rate] * element[qty]);
    }
    return tot;
  }

  // void generateBill() {
  //   num metercost = 0;
  //   num swingcost = 0;

  //   // print(metercost);
  //   // print(swingcost);

  //   // final pdf = pw.Document();
  //   // pdf.addPage(
  //   //   pw.Page(
  //   //     build: (pw.Context context) {
  //   //       return pw.Column(
  //   //         mainAxisAlignment: pw.MainAxisAlignment.start,
  //   //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //   //         children: [
  //   //           // pw.Circle(fillColor: PdfColor.fromInt(0xFF28324B)),
  //   //           pw.Row(
  //   //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //   //             children: [
  //   //               pw.Column(
  //   //                 mainAxisAlignment: pw.MainAxisAlignment.start,
  //   //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //   //                 children: [
  //   //                   pw.Text("Dharmendra K Chauhan"),
  //   //                   pw.Text("PAN No:ANRPC6263H"),
  //   //                 ],
  //   //               ),
  //   //               pw.Column(
  //   //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //   //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
  //   //                 children: [
  //   //                   pw.Text("Dharmesh"),
  //   //                   pw.Text("Mo.9427253352"),
  //   //                   pw.Text("Mo.9979697782"),
  //   //                 ],
  //   //               ),
  //   //             ],
  //   //           ),
  //   //           pw.Text(
  //   //             'Vidhi Curtain',
  //   //             style: pw.TextStyle(
  //   //               fontSize: 24,
  //   //               fontWeight: pw.FontWeight.bold,
  //   //             ),
  //   //           ),
  //   //           pw.SizedBox(height: 15),
  //   //           pw.Text(
  //   //             'Quotation',
  //   //             style: pw.TextStyle(
  //   //               fontSize: 24,
  //   //               fontWeight: pw.FontWeight.bold,
  //   //             ),
  //   //           ),
  //   //           pw.SizedBox(height: 15),
  //   //           pw.Row(
  //   //             children: [
  //   //               pw.Text("Name:", style: pw.TextStyle(fontSize: 20)),
  //   //               pw.Text(
  //   //                 billlist[0]["name"],
  //   //                 style: pw.TextStyle(
  //   //                   fontSize: 20,
  //   //                   decoration: pw.TextDecoration.underline,
  //   //                 ),
  //   //               ),
  //   //             ],
  //   //           ),

  //   //           pw.Row(
  //   //             children: [
  //   //               pw.Text(
  //   //                 "Mobile No.:",
  //   //                 style: pw.TextStyle(
  //   //                   fontSize: 20,
  //   //                   // decoration: pw.TextDecoration.underline,
  //   //                 ),
  //   //               ),
  //   //               pw.Text(
  //   //                 billlist[0]["phone_number"].toString(),
  //   //                 style: pw.TextStyle(
  //   //                   fontSize: 20,
  //   //                   decoration: pw.TextDecoration.underline,
  //   //                 ),
  //   //               ),
  //   //             ],
  //   //           ),
  //   //           pw.SizedBox(height: 20),
  //   //           pw.Table.fromTextArray(
  //   //             cellAlignment: pw.Alignment.center,
  //   //             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //   //             headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
  //   //             headers: ['Description', 'Quantity', 'Price', 'Cost'],

  //   //             data: tableData,
  //   //           ),
  //   //         ],
  //   //       );
  //   //     },
  //   //   ),
  //   // );
  // }

  Future<void> genratepdf() async {
    // ignore: unused_local_variable
    int installcount = 0;
    int socketcount = 0;
    List<List<dynamic>> totalAmounts = [];
    num totalsocketcost = 0;
    num totalmetercost = 0;
    num totalmeter = 0;
    num totalswing = 0;
    num totalaccessory = 0;
    num totalswingcost = 0;
    num totalaccesorycost = 0;
    num totalinstallcharge = 0;
    num finaltotal = 0;

    for (var element in billlist) {
      tableData.add([
        "Meter Cost ",
        element["meter"].toString(),
        element["meter_rate"].toString(),
        (element["meter"] * element["meter_rate"]).toString(),
      ]);
      tableData.add([
        "Swing Cost",
        element["pano"].toString(),
        element["swing_rate"].toString(),
        (element["pano"] * element["swing_rate"]).toString(),
      ]);
      if (element['accesory_size'] != 0) {
        tableData.add([
          "Accessory Cost",
          element["accesory_size"].toString(),
          element["accessories_rate"].toString(),
          (element["accesory_size"] * element["accessories_rate"]).toString(),
        ]);
      }

      if (element["installation_charge"] != 0) {
        tableData.add([
          "Installation Charge",
          "1 Piece",
          element["installation_charge"].toString(),
          element["installation_charge"].toString(),
        ]);
        installcount++;
      }
      if (element["socket_cost"] != 0) {
        tableData.add([
          "Socket Charge",
          "1 Piece",
          element["socket_cost"].toString(),
          element["socket_cost"].toString(),
        ]);
        socketcount++;
      }

      tableData.add([
        "Total Cost (${element['type']} size: ${element['height']}  * ${element['width']})",
        '',

        '',
        element["total_cost"].toString(),
      ]);
      totalmeter += element["meter"];
      totalmetercost += element["meter"] * element["meter_rate"];
      totalswingcost += element["pano"] * element["swing_rate"];
      totalswing += element["pano"];
      totalaccessory += element["accesory_size"];

      totalaccesorycost +=
          element["accesory_size"] * element["accessories_rate"];
      totalinstallcharge += element["installation_charge"];
      totalsocketcost += element["socket_cost"];
    }

    totalAmounts.addAll([
      ["Totel Meter cost", totalmeter, totalmetercost],
      ["Total Swing Cost", totalswing, totalswingcost],
      ["Total Accesory Cost", totalaccessory, totalaccesorycost],
      ["Total Installation Charge", billlist.length, totalinstallcharge],
    ]);
    if (totalsocketcost != 0) {
      totalAmounts.add(["total socket charge", socketcount, totalsocketcost]);
    }
    totalAmounts.add(["Final Total", '', total]);
    logger.i(totalAmounts);

    finaltotal =
        totalmetercost +
        totalswingcost +
        totalaccesorycost +
        totalinstallcharge +
        totalsocketcost;
    logger.i(finaltotal);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Your initial content
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Dharmendra K Chauhan"),
                        pw.Text("PAN No:ANRPC6263H"),
                      ],
                    ),
                    pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Dharmesh"),
                        pw.Text("Mo.9427253352"),
                        pw.Text("Mo.9979697782"),
                      ],
                    ),
                  ],
                ),
                pw.Text(
                  'Vidhi Curtain',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  'Quotation',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Row(
                  children: [
                    pw.Text("Name:", style: pw.TextStyle(fontSize: 20)),
                    pw.Text(
                      billlist[0]["name"],
                      style: pw.TextStyle(
                        fontSize: 20,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text("Mobile No.:", style: pw.TextStyle(fontSize: 20)),
                    pw.Text(
                      billlist[0]["phone_number"].toString(),
                      style: pw.TextStyle(
                        fontSize: 20,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  cellAlignment: pw.Alignment.center,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  headers: ['Description', 'Quantity', 'Price', 'Cost'],
                  data: tableData,
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  cellAlignment: pw.Alignment.center,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  headers: ['Description', 'Quantity', 'Cost'],
                  data: totalAmounts,
                ),

                // Add more content if needed, and `pw.MultiPage` will handle breaking pages
              ],
            ),
          ];
        },
      ),
    );
    // Save the PDF file to the device
    final output = await getApplicationCacheDirectory();
    final file = File('${output.path}/${billlist[0]["name"]}.pdf');
    await file.writeAsBytes(await pdf.save());
    Get.snackbar(
      "saved",
      file.path,
      onTap: (snack) async {
        logger.i("open");
        await OpenFilex.open(file.path);
      },
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    try {
      final response = await supabase
          .from("orders")
          .select()
          .order('id', ascending: false);
      orders.value = List<Map<String, dynamic>>.from(response);
      checklist.value = List.generate(
        orders.length,
        (index) => false,
      ); // Make checklist reactive
      return orders;
    } catch (e) {
      logger.e("Error fetching data: $e");
      return [];
    }
  }

  // Toggle checklist item
  void toggleCheckListItem(int index) {
    checklist[index] = !checklist[index];
    if (checklist[index]) {
      billlist.add(orders[index]);
      total.value += orders[index]["total_cost"];
      logger.i(billlist);
      // print(billlist);
    } else {
      total.value -= orders[index]["total_cost"];
      billlist.remove(orders[index]);
      // logger.i(billlist);
    }
  }
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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

  List<Map<String, dynamic>> addMetersIfSameRate() {
    Map<double, double> meterSums = {};
    Map<double, Map<String, dynamic>> uniqueRecords = {};

    for (var record in billlist) {
      double meterRate = record['meter_rate'];
      if (meterSums.containsKey(meterRate)) {
        meterSums[meterRate] = meterSums[meterRate]! + record['meter'];
      } else {
        meterSums[meterRate] = record['meter'];
        uniqueRecords[meterRate] = record;
      }
    }

    // Update the records with the summed meters
    uniqueRecords.forEach((rate, record) {
      record['meter'] = meterSums[rate]!;
    });

    return uniqueRecords.values.toList();
  }

  Future<void> genratepdf() async {
    tableData.value = [];

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // pw.Circle(fillColor: PdfColor.fromInt(0xFF28324B)),
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
                  pw.Text(
                    "Name:",
                    style: pw.TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                    ),
                  ),
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
                  pw.Text(
                    "Mobile No.:",
                    style: pw.TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                    ),
                  ),
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
                headers: ['Description', 'Quantity', 'Price', 'Cost'],
                data: tableData,
              ),
            ],
          );
        },
      ),
    );
    // Save the PDF file to the device
    final output = await getDownloadsDirectory();
    final file = File('${output!.path}/${billlist[0]["name"]}.pdf');
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
      final response = await supabase.from("orders").select();
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
      print(billlist);
    } else {
      total.value -= orders[index]["total_cost"];
      billlist.remove(orders[index]);
      logger.i(billlist);
    }
  }
}

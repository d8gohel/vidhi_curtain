import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' as mp;
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:vidhiadmin/app/data/productmodel.dart';
import 'package:vidhiadmin/app/data/windowmodel.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

import '../../../data/usermodel.dart';

class OrdersController extends GetxController {
  WindowModel? selectedWindow;
  RxString username = ''.obs;
  RxString phoneNumber = ''.obs;
  RxDouble height = 0.0.obs;
  RxDouble width = 0.0.obs;
  RxDouble price = 0.0.obs;
  RxString selectedOption = '120'.obs;
  List<UserModel> users = [];
  List<WindowModel> windows = [];
  bool ispipefitted = false;

  RxList<List<dynamic>> tableData = <List<dynamic>>[].obs;
  List saveddata = [];
  final supabase = Supabase.instance.client;
  RxDouble totalCost = 0.0.obs;

  List<Product> items = <Product>[].obs;
  var logger = Logger(filter: null, printer: PrettyPrinter(), output: null);

  double pano = 0;

  double foot = 0;

  double meter = 0;

  int installCharge = 0;

  double sewingCost = 0;

  double accessoryPrice = 0;

  double feet = 0;
  @override
  void onInit() {
    super.onInit();

    fetchProducts();
    fetchdata();
  }

  FutureOr<List<String>?> suggetions(pattern) async {
    // Fetch suggestions based on user input
    var filteredData =
        users
            .where(
              (user) =>
                  user.firstName.toLowerCase().contains(pattern.toLowerCase()),
            )
            .map((user) => user.firstName)
            .toList();

    return filteredData;
  }

  Future<void> fetchdata() async {
    final response = await supabase.from('users').select();
    final res1 = await supabase.from("windows").select();

    logger.i(res1);
    logger.i(response);

    users = response.map((json) => UserModel.fromJson(json)).toList();
    windows = res1.map((json) => WindowModel.fromJson(json)).toList();
  }

  Future<void> savedata() async {
    saveddata.add(tableData);
    print(height.value);
    print(width.value);
    var data = {
      "name": username.value,
      "height": height.value,
      "width": width.value,
      "phone_number": phoneNumber.value,
      "type": selectedOption.value == '120' ? "Arabian" : "ring",
      "meter": meter,
      "meter_rate": price.value,
      "pano": pano,
      "swing_rate": selectedOption.value == '120' ? 120 : 210,
      "accessories_rate":
          ispipefitted == false
              ? selectedOption.value == '120'
                  ? 250
                  : 40
              : 0,
      "accesory_size": ispipefitted == false ? feet : 0,
      "installation_charge": ispipefitted == false ? installCharge : 0,
      "socket_cost":
          selectedOption.value == '210' && ispipefitted == false ? 200 : 0,
      "total_cost": totalCost.value,
    };

    await supabase.from("orders").insert(data);
  }

  void count() {
    double heightValue = height.value + 12;

    pano = (width.value / 22).ceilToDouble();
    foot = heightValue * pano;
    meter = foot / 39;
    meter = toQuarterSection(meter);

    installCharge = selectedOption.value == '120' ? 200 : 150;
    sewingCost = pano * (selectedOption.value == '120' ? 120 : 210); // Example
    double meterCost = price.value * meter;
    accessoryPrice =
        selectedOption.value == '120'
            ? ((width.value * 2 / 12).round() / 2 * 250)
            : 0.0;

    double totalCostValue = sewingCost + meterCost;
    if (ispipefitted == false) {
      totalCostValue += accessoryPrice + installCharge;
    }
    if (selectedOption.value == '210' && ispipefitted == false) {
      totalCostValue += (width.value * 2 / 12).round() / 2 * 40 + 200;
    }
    feet = width / 12;

    // Round up if the decimal part of the width is greater than 0.5
    if (feet - feet.toInt() > 0.5) {
      // feet += 1;
      feet =
          feet.roundToDouble(); // Add 1 if the decimal part is greater than 0.5
    } else {
      feet = feet.toInt() + 0.5; // Otherwise, just convert to integer
    }

    tableData.value = [
      ['Meter Cost  ', meter, price.value, meterCost],
      [
        'Swing Cost (With Material)',
        pano,
        (selectedOption.value == '120' ? 120 : 210),
        sewingCost,
      ],
      if (selectedOption.value == '120' && ispipefitted == false)
        [
          'Accessory Cost',
          (width.value * 2 / 12).round() / 2,
          250,
          accessoryPrice,
        ],
      if (selectedOption.value == '210' && ispipefitted == false)
        ['Pipe Cost', '$feet feet', 40, feet * 40],
      if (selectedOption.value == '210' && ispipefitted == false)
        ['Socket Cost', '1 pair', 200, 200],
      if (ispipefitted == false)
        ["Installation Charge", '1 Pc.', installCharge, installCharge],
      ['Total Cost', '', '', totalCostValue],
    ];

    totalCost.value = totalCostValue;
    Get.forceAppUpdate();
    Get.dialog(
      mp.AlertDialog(
        shape: mp.BeveledRectangleBorder(),
        title: mp.Text('Download PDF'),
        content: mp.Text('Do you want to download the quotation as a PDF?'),
        actions: [
          mp.TextButton(
            onPressed: () {
              // Dismiss the dialog
              Get.back();
            },

            child: mp.Text('Cancel'),
          ),
          mp.TextButton(
            onPressed: () {
              // Generate the PDF if the user confirms
              generatePDF(tableData, totalCostValue);
              // Dismiss the dialog
              Get.back();
            },
            style: Styles.buttonstyle,
            child: mp.Text('Download'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchProducts() async {
    final response =
        await Supabase.instance.client
            .from('products') // Replace 'products' with your table name
            .select();

    var data = response as List;
    items = data.map((e) => Product.fromJson(e)).toList();
    // print(items);
  }

  double toQuarterSection(double value) {
    return (value * 4).round() / 4;
  }

  void generatePDF(List<List<dynamic>> tableData, double totalCostValue) async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // pw.Circle(fillColor: PdfColor.fromInt(0xFF28324B)),
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pw.Text("Dharmendra K Chauhan"),
                      pw.Text("PAN No:ANRPC6263H"),
                    ],
                  ),
                  pw.Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                    style: TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.Text(
                    username.value,
                    style: TextStyle(
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
                    style: TextStyle(
                      fontSize: 20,
                      // decoration: pw.TextDecoration.underline,
                    ),
                  ),
                  pw.Text(
                    phoneNumber.value,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
                cellAlignment: Alignment.center,
                headers: ['Description', 'Quantity', 'Price', 'Cost'],
                data: tableData,
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Cost: ${totalCostValue.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Signature(name: "Dharmendra K Chauhan"),
            ],
          );
        },
      ),
    );

    // Save the PDF file to the device
    final output = await getDownloadsDirectory();
    final file = File('${output!.path}/${username.value}.pdf');
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
}

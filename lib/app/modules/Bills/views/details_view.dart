import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DetailsView extends GetView {
  final Map data;
  const DetailsView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Convert the customer data map to a list of table rows
    List<TableRow> tableRows =
        data.entries.map((entry) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key.replaceAll('_', ' '),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${entry.value}'),
              ),
            ],
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Table(border: TableBorder.all(), children: tableRows),
        ),
      ),
    );
  }
}

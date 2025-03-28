import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

void showYesNoDialog(Function function) {
  Get.defaultDialog(
    radius: 0,

    title: 'Confirm Action',
    middleText: 'Are you sure you want to Delete?',
    onCancel: () {
      Get.snackbar('Cancelled', 'You cancelled the action');
    },
    onConfirm: () {
      function;
      Get.snackbar('Confirmed', 'You confirmed the action');
    },
    confirm: ElevatedButton(
      style: Styles.buttonstyle,
      onPressed: () {
        function;
        Get.back();
      },
      child: Text('Yes'),
    ),
    cancel: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        Get.back();
      },
      child: Text('No'),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

import 'package:vidhiadmin/app/data/productmodel.dart';
import 'package:vidhiadmin/app/modules/Products/controllers/products_controller.dart';
import 'package:vidhiadmin/app/modules/utils/commontextfield.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

void showProductBottomSheet(ProductController controller, {Product? product}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController(
    text: product?.cloathName ?? '',
  );
  final TextEditingController fileController = TextEditingController(
    text: product?.fileName ?? '',
  );
  final TextEditingController brandController = TextEditingController(
    text: product?.brandName ?? '',
  );
  final TextEditingController priceController = TextEditingController(
    text: product?.price.toString() ?? '',
  );

  // final ImagePicker picker = ImagePicker();

  Get.bottomSheet(
    shape: BeveledRectangleBorder(),
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product == null ? "Add Product" : "Edit Product",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            CommonTextField(
              controller: nameController,
              label: 'Sr NO',
              iconData: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter serial number';
                }
                return null;
              },
            ),
            CommonTextField(
              controller: fileController,
              iconData: Icons.file_copy_sharp,
              label: 'File Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter file name';
                }
                return null;
              },
            ),
            CommonTextField(
              controller: brandController,
              label: 'Brand Name',
              iconData: Icons.branding_watermark,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter brand name';
                }
                return null;
              },
            ),
            CommonTextField(
              controller: priceController,
              label: 'Price',
              textInputType: TextInputType.number,
              iconData: Icons.currency_rupee,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),

            // Display the selected image if available
          Obx(() {
  final selectedImage = controller.selectedImage.value;
  final imageUrl = product?.imageUrl;

  return (selectedImage != null || imageUrl != null)
      ? Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: GestureDetector(
                onTap: () => controller.selectedImage.value = null,
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        )
      : const Text("No image selected");
}),
ElevatedButton(
  onPressed: () async => await controller.showimage(),
  style: Styles.buttonstyle,
  child: const Text('Pick Image'),
),

            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  controller.saveProduct(
                    Product(
                      productId: product?.productId,
                      cloathName: nameController.text,
                      fileName: fileController.text,
                      brandName: brandController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      imageUrl: product?.imageUrl ?? '',
                    ),
                    controller.selectedImage.value,
                  );
                }
              },
              style: Styles.buttonstyle,
              child: Text(product == null ? 'Add Product' : 'Update Product'),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

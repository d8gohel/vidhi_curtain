import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:vidhiadmin/app/data/productmodel.dart';
import 'package:vidhiadmin/app/modules/Products/controllers/products_controller.dart';
import 'package:vidhiadmin/app/modules/utils/commontextfield.dart';

void showProductBottomSheet(ProductController controller, {Product? product}) {
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
          ),
          CommonTextField(
            controller: fileController,
            iconData: Icons.file_copy_sharp,
            label: 'File Name',
          ),
          CommonTextField(
            controller: brandController,
            label: 'Brand Name',
            iconData: Icons.branding_watermark,
          ),
          CommonTextField(
            controller: priceController,
            label: 'Price',
            iconData: Icons.currency_rupee,
          ),

          // Display the selected image if available
          if (controller.selectedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.file(
                controller.selectedImage!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

          ElevatedButton(
            onPressed: () {
              controller.showimage();
            },
            child: Text('Pick Image'),
          ),

          ElevatedButton(
            onPressed: () {
              controller.saveProduct(
                Product(
                  productId: product?.productId,
                  cloathName: nameController.text,
                  fileName: fileController.text,
                  brandName: brandController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  imageUrl: product?.imageUrl ?? '',
                ),
                controller.selectedImage,
              );
            },
            child: Text(product == null ? 'Add Product' : 'Update Product'),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

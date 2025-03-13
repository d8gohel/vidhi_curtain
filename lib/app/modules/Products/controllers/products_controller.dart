import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/productmodel.dart';

class ProductController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;
  var products = <Product>[].obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final response = await supabase.from('products').select();
      products.assignAll(
        response.map((data) => Product.fromJson(data)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Upload image to Supabase Storage
  Future<String?> uploadImage(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload the file to Supabase storage
      await supabase.storage.from('curtains').upload(fileName, file);

      // Get the public URL of the uploaded image
      final publicUrl = supabase.storage
          .from('curtains')
          .getPublicUrl(fileName);
      print('Image uploaded successfully: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('Upload Image Error: $e');
      Get.snackbar('Error', 'Image upload failed');
      return null;
    }
  }

  Future<File?> showimage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      Logger().i(selectedImage.value?.path);
    }
    return selectedImage.value;
  }

  // Add or Update Product
  Future<void> saveProduct(Product product, File? image) async {
    if (product.cloathName.isEmpty ||
        product.fileName.isEmpty ||
        product.brandName.isEmpty ||
        product.price <= 0 ||
        (image == null && product.imageUrl!.isEmpty)) {
      Get.snackbar('Error', 'All fields including image are required!');
      return;
    }

    isLoading(true);
    try {
      String? imageUrl = product.imageUrl;

      if (image != null) {
        String? uploadedImageUrl = await uploadImage(image);
        if (uploadedImageUrl == null) return;
        imageUrl = uploadedImageUrl;
      }

      final data = product.toJson();
      data['image_url'] = imageUrl;

      print('Saving Data: $data');

      if (product.productId == null) {
        await supabase.from('products').insert(data);
      } else {
        await supabase
            .from('products')
            .update(data)
            .eq('productid', product.productId.toString());
      }

      fetchProducts();
      Get.back();
      Get.snackbar('Success', 'Product saved successfully');
    } catch (e) {
      print('Save Product Error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Delete Product
  Future<void> deleteProduct(String productId) async {
    isLoading(true);
    try {
      await supabase.from('products').delete().eq('productid', productId);
      fetchProducts();
      Get.snackbar('Success', 'Product deleted');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}

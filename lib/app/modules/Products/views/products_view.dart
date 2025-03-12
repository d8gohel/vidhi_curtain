import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhiadmin/app/modules/Products/controllers/products_controller.dart';
import 'package:vidhiadmin/app/modules/Products/views/bottomsheet.dart';
import 'package:vidhiadmin/app/modules/utils/styles.dart';

import '../../../data/productmodel.dart';

class ProductsView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final TextEditingController searchController = TextEditingController();

  ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearch(controller.products),
                );
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(child: Text('No products available'));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Platform.isWindows ? 7 : 2, // Number of columns
            crossAxisSpacing: 10, // Space between columns
            mainAxisSpacing: 10, // Space between rows
            childAspectRatio: 0.7, // Adjust the aspect ratio of each grid item
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(product.imageUrl.toString()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                style: Styles.buttonstyle,
                                onPressed: () {
                                  controller.deleteProduct(
                                    product.productId.toString(),
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                              SizedBox(width: 5),
                              IconButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  showProductBottomSheet(
                                    controller,
                                    product: product,
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.sanchez(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "${product.cloathName} ",
                                style: GoogleFonts.sanchez(fontSize: 20),
                              ),
                              TextSpan(
                                text: "\n${product.fileName} ",
                                style: GoogleFonts.sanchez(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${product.price.toString()}',
                          style: GoogleFonts.sanchez(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductBottomSheet(controller),
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductSearch extends SearchDelegate {
  final List<Product> products;

  ProductSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts =
        products
            .where(
              (product) => product.cloathName.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          title: Text(product.cloathName),
          subtitle: Text('₹${product.price.toString()}'),
          onTap: () {
            close(context, null); // Close search when a product is selected
            showProductBottomSheet(
              Get.find<ProductController>(),
              product: product,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts =
        products
            .where(
              (product) => product.cloathName.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          title: Text(product.cloathName),
          subtitle: Text('₹${product.price.toString()}'),
          onTap: () {
            query = product.cloathName; // Update search query when tapped
            showResults(context);
          },
        );
      },
    );
  }
}

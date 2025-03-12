class Product {
  final int? productId;
  final String cloathName;
  final String fileName;
  final String brandName;
  final double price;
  final String? imageUrl;

  Product({
    this.productId,
    required this.cloathName,
    required this.fileName,
    required this.brandName,
    required this.price,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'cloath_name': cloathName,
      'file_name': fileName,
      'brand_name': brandName,
      'price': price,
      'image_url': imageUrl,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productid'],
      cloathName: json['cloath_name'],
      fileName: json['file_name'],
      brandName: json['brand_name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}

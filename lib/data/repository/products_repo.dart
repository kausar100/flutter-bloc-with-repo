import 'package:hello_flutter/data/model/product.dart';

class ProductsRepository {
  final List<Product> products = [];

  Future<List<Product>> initialProducts() async {
    await Future.delayed(const Duration(seconds: 1), () {
      products.addAll(Product.initialProducts);
    });
    return products;
  }

  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1), () {
      products.add(product);
    });
  }

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return products;
  }
}

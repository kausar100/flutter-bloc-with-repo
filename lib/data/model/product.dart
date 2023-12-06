class Product {
  String name;
  int price;

  Product({required this.name, required this.price});

  static List<Product> initialProducts = List.generate(
      5, (index) => Product(name: "product ${index + 1}", price: index * 2));
}

class Products {
  final int id;
  final String title;
  final String image;
  final double price;
  final String description;
  final String brand;
  final String model;
  final String color;
  final String category;
  final int discount;

  Products({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.brand,
    required this.model,
    required this.color,
    required this.category,
    required this.discount,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? 'No Description',
      brand: json['brand'] ?? 'Unknown Brand',
      model: json['model'] ?? 'Unknown Model',
      color: json['color'] ?? 'Unknown Color',
      category: json['category'] ?? 'Unknown Category',
      discount: json['discount'] ?? 0,
    );
  }
}

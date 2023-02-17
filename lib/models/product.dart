// To parse this JSON data, do
//
//     final Product = ProductFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.favorite,
    required this.price,
  });

  int id;
  String name;
  String description;
  bool favorite;
  double price;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        favorite: json["favorite"],
        price: json["price"],
      );
}

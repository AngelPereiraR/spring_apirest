// To parse this JSON data, do
//
//     final Category = CategoryFromMap(jsonString);

import 'dart:convert';

class Category {
  Category({
    required this.id,
    required this.name,
    required this.description,
    this.categoryId,
  });

  int id;
  String name;
  String description;
  dynamic categoryId;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        categoryId: json["categoryId"],
      );
}

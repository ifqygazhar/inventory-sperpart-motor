import 'package:inventory_motor/utils/status.dart';

class ProductHistory {
  const ProductHistory({
    required this.id,
    required this.productId,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.image,
  });

  final String id;
  final String productId;
  final String title;
  final DateTime date;
  final Status status;
  final String description;
  final String image;

  ProductHistory copyWith({
    String? id,
    String? productId,
    String? title,
    DateTime? date,
    Status? status,
    String? description,
    String? image,
  }) {
    return ProductHistory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  static Status statusFromString(String status) {
    return Status.values
        .firstWhere((e) => e.toString().split('.').last == status);
  }

  static String statusToString(Status status) {
    return status.toString().split('.').last;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'title': title,
      'date': date.toIso8601String(),
      'status': statusToString(status),
      'description': description,
      'image': image,
    };
  }

  factory ProductHistory.fromMap(Map<String, dynamic> map) {
    return ProductHistory(
      id: map['id'],
      productId: map['product_id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: statusFromString(map['status']),
      description: map['description'],
      image: map['image'],
    );
  }

  List<dynamic> toList() {
    return [
      id,
      productId,
      title,
      date.toIso8601String(),
      statusToString(status),
      description,
      image,
    ];
  }
}

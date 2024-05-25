import 'package:inventory_motor/utils/status.dart';

class ProductHistory {
  const ProductHistory({
    required this.id,
    required this.productId,
    required this.title,
    required this.date,
    required this.status,
    required this.entry,
    required this.exit,
    required this.description,
    required this.image,
  });

  final String id;
  final String productId;
  final String title;
  final DateTime date;
  final Status status;
  final int entry;
  final int exit;
  final String description;
  final String image;

  ProductHistory copyWith({
    String? id,
    String? productId,
    String? title,
    DateTime? date,
    Status? status,
    int? entry,
    int? exit,
    String? description,
    String? image,
  }) {
    return ProductHistory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      entry: entry ?? this.entry,
      exit: exit ?? this.exit,
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
      'entry': entry,
      'exit': exit,
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
      entry: map['entry'],
      exit: map['exit'],
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
      entry,
      exit,
      description,
      image,
    ];
  }
}

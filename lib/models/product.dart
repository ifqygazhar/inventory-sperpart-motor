import 'package:inventory_motor/utils/status.dart';

class Product {
  final String id;
  final String title;
  final DateTime date;
  final Status status;
  final int entry;
  final int exit;
  final String description;
  final String image;
  final int total;

  Product({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.entry,
    required this.exit,
    required this.description,
    required this.image,
    required this.total,
  });

  Product copyWith({
    String? id,
    String? title,
    DateTime? date,
    Status? status,
    int? entry,
    int? exit,
    String? description,
    String? image,
    int? total,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      entry: entry ?? this.entry,
      exit: exit ?? this.exit,
      description: description ?? this.description,
      image: image ?? this.image,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'entry': entry,
      'exit': exit,
      'description': description,
      'image': image,
      'total': total,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: Status.values.firstWhere((e) => e.toString() == map['status']),
      entry: map['entry'],
      exit: map['exit'],
      description: map['description'],
      image: map['image'],
      total: map['total'],
    );
  }

  static String statusToString(Status status) {
    return status.toString().split('.').last;
  }

  List<dynamic> toList() {
    return [
      id,
      title,
      date.toIso8601String(),
      statusToString(status),
      entry,
      exit,
      description,
      image,
      total,
    ];
  }
}

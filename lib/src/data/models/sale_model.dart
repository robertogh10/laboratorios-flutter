import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laboratorio_experinece_app/src/data/models/bag_item_model.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';

class SaleModel {
  const SaleModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory SaleModel.fromEntity(Sale sale) {
    return SaleModel(
      id: sale.id,
      userId: sale.userId,
      userEmail: sale.userEmail,
      items: sale.items.map(BagItemModel.fromEntity).toList(),
      total: sale.total,
      paymentMethod: sale.paymentMethod,
      status: sale.status,
      createdAt: sale.createdAt,
    );
  }

  factory SaleModel.fromJson({
    required String id,
    required Map<String, Object?> json,
  }) {
    return SaleModel(
      id: id,
      userId: json['userId'] as String,
      userEmail: (json['userEmail'] as String?) ?? '',
      items: (json['items'] as List)
          .map(
            (item) =>
                BagItemModel.fromJson(Map<String, Object?>.from(item as Map)),
          )
          .toList(),
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: (json['status'] as String?) ?? 'created',
      createdAt: _dateTimeFromJson(json['createdAt']),
    );
  }

  final String id;
  final String userId;
  final String userEmail;
  final List<BagItemModel> items;
  final double total;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  Sale toEntity() {
    return Sale(
      id: id,
      userId: userId,
      userEmail: userEmail,
      items: items.map((item) => item.toEntity()).toList(),
      total: total,
      paymentMethod: paymentMethod,
      status: status,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toUtc(),
    };
  }

  static DateTime _dateTimeFromJson(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}

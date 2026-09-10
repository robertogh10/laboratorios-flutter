import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';

class Sale {
  const Sale({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userEmail;
  final List<BagItem> items;
  final double total;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
}

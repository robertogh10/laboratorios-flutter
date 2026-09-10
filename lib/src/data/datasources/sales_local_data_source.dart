import 'dart:async';
import 'dart:convert';

import 'package:laboratorio_experinece_app/src/core/local_storage.dart';
import 'package:laboratorio_experinece_app/src/data/datasources/sales_data_source.dart';
import 'package:laboratorio_experinece_app/src/data/models/sale_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesLocalDataSource implements SalesDataSource {
  SalesLocalDataSource({SharedPreferences? sharedPreferences})
    : _prefs = sharedPreferences ?? LocalStorage().prefs;

  static const _salesKey = 'sales';

  final SharedPreferences _prefs;
  final _controller = StreamController<List<SaleModel>>.broadcast();

  @override
  Future<SaleModel> createSale(SaleModel sale) async {
    final savedSale = SaleModel(
      id: sale.id.isEmpty
          ? 'sale-${DateTime.now().microsecondsSinceEpoch}'
          : sale.id,
      userId: sale.userId,
      userEmail: sale.userEmail,
      items: sale.items,
      total: sale.total,
      paymentMethod: sale.paymentMethod,
      status: sale.status,
      createdAt: sale.createdAt,
    );
    final sales = [..._readSales(), savedSale];

    await _prefs.setString(
      _salesKey,
      jsonEncode(
        sales
            .map(
              (item) => {
                'id': item.id,
                ...item.toJson(),
                'createdAt': item.createdAt.toUtc().toIso8601String(),
              },
            )
            .toList(),
      ),
    );
    _controller.add(_sorted(sales));

    return savedSale;
  }

  @override
  Stream<List<SaleModel>> watchSales({
    required String userId,
    required bool isAdmin,
  }) async* {
    List<SaleModel> visibleSales(List<SaleModel> sales) {
      final filtered = isAdmin
          ? sales
          : sales.where((sale) => sale.userId == userId).toList();
      return _sorted(filtered);
    }

    yield visibleSales(_readSales());
    yield* _controller.stream.map(visibleSales);
  }

  List<SaleModel> _readSales() {
    final saved = _prefs.getString(_salesKey);

    if (saved == null || saved.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(saved) as List;
      return decoded.map((item) {
        final json = Map<String, Object?>.from(item as Map);
        return SaleModel.fromJson(id: json.remove('id') as String, json: json);
      }).toList();
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  List<SaleModel> _sorted(List<SaleModel> sales) {
    return [...sales]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

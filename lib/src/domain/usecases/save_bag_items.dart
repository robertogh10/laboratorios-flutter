import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class SaveBagItems {
  const SaveBagItems(this._repository);

  final StoreRepository _repository;

  Future<void> call(List<BagItem> items) {
    return _repository.saveBagItems(items);
  }
}

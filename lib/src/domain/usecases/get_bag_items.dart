import 'package:laboratorio_experinece_app/src/domain/entities/bag_item.dart';
import 'package:laboratorio_experinece_app/src/domain/repositories/store_repository.dart';

class GetBagItems {
  const GetBagItems(this._repository);

  final StoreRepository _repository;

  List<BagItem> call() {
    return _repository.getBagItems();
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/interest.dart';

part 'interest_model.freezed.dart';

@freezed
abstract class InterestModel with _$InterestModel {
  const InterestModel._();

  const factory InterestModel({
    required String id,
    required String title,
    required bool selected,
  }) = _InterestModel;

  Interest toEntity() {
    return Interest(id: id, title: title, selected: selected);
  }
}

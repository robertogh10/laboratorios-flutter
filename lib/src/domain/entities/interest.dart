import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest.freezed.dart';

@freezed
abstract class Interest with _$Interest {
  const factory Interest({
    required String id,
    required String title,
    required bool selected,
  }) = _Interest;
}

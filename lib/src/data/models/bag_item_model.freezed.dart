// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bag_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BagItemModel {

 ProductModel get product; int get quantity;
/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BagItemModelCopyWith<BagItemModel> get copyWith => _$BagItemModelCopyWithImpl<BagItemModel>(this as BagItemModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BagItemModel&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,product,quantity);

@override
String toString() {
  return 'BagItemModel(product: $product, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $BagItemModelCopyWith<$Res>  {
  factory $BagItemModelCopyWith(BagItemModel value, $Res Function(BagItemModel) _then) = _$BagItemModelCopyWithImpl;
@useResult
$Res call({
 ProductModel product, int quantity
});


$ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class _$BagItemModelCopyWithImpl<$Res>
    implements $BagItemModelCopyWith<$Res> {
  _$BagItemModelCopyWithImpl(this._self, this._then);

  final BagItemModel _self;
  final $Res Function(BagItemModel) _then;

/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [BagItemModel].
extension BagItemModelPatterns on BagItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BagItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BagItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BagItemModel value)  $default,){
final _that = this;
switch (_that) {
case _BagItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BagItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _BagItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductModel product,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BagItemModel() when $default != null:
return $default(_that.product,_that.quantity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductModel product,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _BagItemModel():
return $default(_that.product,_that.quantity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductModel product,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _BagItemModel() when $default != null:
return $default(_that.product,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _BagItemModel extends BagItemModel {
  const _BagItemModel({required this.product, required this.quantity}): super._();
  

@override final  ProductModel product;
@override final  int quantity;

/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BagItemModelCopyWith<_BagItemModel> get copyWith => __$BagItemModelCopyWithImpl<_BagItemModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BagItemModel&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,product,quantity);

@override
String toString() {
  return 'BagItemModel(product: $product, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$BagItemModelCopyWith<$Res> implements $BagItemModelCopyWith<$Res> {
  factory _$BagItemModelCopyWith(_BagItemModel value, $Res Function(_BagItemModel) _then) = __$BagItemModelCopyWithImpl;
@override @useResult
$Res call({
 ProductModel product, int quantity
});


@override $ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class __$BagItemModelCopyWithImpl<$Res>
    implements _$BagItemModelCopyWith<$Res> {
  __$BagItemModelCopyWithImpl(this._self, this._then);

  final _BagItemModel _self;
  final $Res Function(_BagItemModel) _then;

/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? quantity = null,}) {
  return _then(_BagItemModel(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BagItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on

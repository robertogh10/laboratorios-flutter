// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreState {

 StoreView get view; List<Product> get products; List<BagItem> get bagItems; List<PaymentMethod> get paymentMethods; String get selectedProductId; String get selectedPaymentMethodId; bool get billingSameAsShipping;
/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreStateCopyWith<StoreState> get copyWith => _$StoreStateCopyWithImpl<StoreState>(this as StoreState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreState&&(identical(other.view, view) || other.view == view)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.bagItems, bagItems)&&const DeepCollectionEquality().equals(other.paymentMethods, paymentMethods)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.selectedPaymentMethodId, selectedPaymentMethodId) || other.selectedPaymentMethodId == selectedPaymentMethodId)&&(identical(other.billingSameAsShipping, billingSameAsShipping) || other.billingSameAsShipping == billingSameAsShipping));
}


@override
int get hashCode => Object.hash(runtimeType,view,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(bagItems),const DeepCollectionEquality().hash(paymentMethods),selectedProductId,selectedPaymentMethodId,billingSameAsShipping);

@override
String toString() {
  return 'StoreState(view: $view, products: $products, bagItems: $bagItems, paymentMethods: $paymentMethods, selectedProductId: $selectedProductId, selectedPaymentMethodId: $selectedPaymentMethodId, billingSameAsShipping: $billingSameAsShipping)';
}


}

/// @nodoc
abstract mixin class $StoreStateCopyWith<$Res>  {
  factory $StoreStateCopyWith(StoreState value, $Res Function(StoreState) _then) = _$StoreStateCopyWithImpl;
@useResult
$Res call({
 StoreView view, List<Product> products, List<BagItem> bagItems, List<PaymentMethod> paymentMethods, String selectedProductId, String selectedPaymentMethodId, bool billingSameAsShipping
});




}
/// @nodoc
class _$StoreStateCopyWithImpl<$Res>
    implements $StoreStateCopyWith<$Res> {
  _$StoreStateCopyWithImpl(this._self, this._then);

  final StoreState _self;
  final $Res Function(StoreState) _then;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? view = null,Object? products = null,Object? bagItems = null,Object? paymentMethods = null,Object? selectedProductId = null,Object? selectedPaymentMethodId = null,Object? billingSameAsShipping = null,}) {
  return _then(_self.copyWith(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as StoreView,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,bagItems: null == bagItems ? _self.bagItems : bagItems // ignore: cast_nullable_to_non_nullable
as List<BagItem>,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,selectedProductId: null == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String,selectedPaymentMethodId: null == selectedPaymentMethodId ? _self.selectedPaymentMethodId : selectedPaymentMethodId // ignore: cast_nullable_to_non_nullable
as String,billingSameAsShipping: null == billingSameAsShipping ? _self.billingSameAsShipping : billingSameAsShipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreState].
extension StoreStatePatterns on StoreState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreState value)  $default,){
final _that = this;
switch (_that) {
case _StoreState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreState value)?  $default,){
final _that = this;
switch (_that) {
case _StoreState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StoreView view,  List<Product> products,  List<BagItem> bagItems,  List<PaymentMethod> paymentMethods,  String selectedProductId,  String selectedPaymentMethodId,  bool billingSameAsShipping)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that.view,_that.products,_that.bagItems,_that.paymentMethods,_that.selectedProductId,_that.selectedPaymentMethodId,_that.billingSameAsShipping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StoreView view,  List<Product> products,  List<BagItem> bagItems,  List<PaymentMethod> paymentMethods,  String selectedProductId,  String selectedPaymentMethodId,  bool billingSameAsShipping)  $default,) {final _that = this;
switch (_that) {
case _StoreState():
return $default(_that.view,_that.products,_that.bagItems,_that.paymentMethods,_that.selectedProductId,_that.selectedPaymentMethodId,_that.billingSameAsShipping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StoreView view,  List<Product> products,  List<BagItem> bagItems,  List<PaymentMethod> paymentMethods,  String selectedProductId,  String selectedPaymentMethodId,  bool billingSameAsShipping)?  $default,) {final _that = this;
switch (_that) {
case _StoreState() when $default != null:
return $default(_that.view,_that.products,_that.bagItems,_that.paymentMethods,_that.selectedProductId,_that.selectedPaymentMethodId,_that.billingSameAsShipping);case _:
  return null;

}
}

}

/// @nodoc


class _StoreState implements StoreState {
  const _StoreState({required this.view, required final  List<Product> products, required final  List<BagItem> bagItems, required final  List<PaymentMethod> paymentMethods, required this.selectedProductId, required this.selectedPaymentMethodId, required this.billingSameAsShipping}): _products = products,_bagItems = bagItems,_paymentMethods = paymentMethods;
  

@override final  StoreView view;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<BagItem> _bagItems;
@override List<BagItem> get bagItems {
  if (_bagItems is EqualUnmodifiableListView) return _bagItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bagItems);
}

 final  List<PaymentMethod> _paymentMethods;
@override List<PaymentMethod> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}

@override final  String selectedProductId;
@override final  String selectedPaymentMethodId;
@override final  bool billingSameAsShipping;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreStateCopyWith<_StoreState> get copyWith => __$StoreStateCopyWithImpl<_StoreState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreState&&(identical(other.view, view) || other.view == view)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._bagItems, _bagItems)&&const DeepCollectionEquality().equals(other._paymentMethods, _paymentMethods)&&(identical(other.selectedProductId, selectedProductId) || other.selectedProductId == selectedProductId)&&(identical(other.selectedPaymentMethodId, selectedPaymentMethodId) || other.selectedPaymentMethodId == selectedPaymentMethodId)&&(identical(other.billingSameAsShipping, billingSameAsShipping) || other.billingSameAsShipping == billingSameAsShipping));
}


@override
int get hashCode => Object.hash(runtimeType,view,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_bagItems),const DeepCollectionEquality().hash(_paymentMethods),selectedProductId,selectedPaymentMethodId,billingSameAsShipping);

@override
String toString() {
  return 'StoreState(view: $view, products: $products, bagItems: $bagItems, paymentMethods: $paymentMethods, selectedProductId: $selectedProductId, selectedPaymentMethodId: $selectedPaymentMethodId, billingSameAsShipping: $billingSameAsShipping)';
}


}

/// @nodoc
abstract mixin class _$StoreStateCopyWith<$Res> implements $StoreStateCopyWith<$Res> {
  factory _$StoreStateCopyWith(_StoreState value, $Res Function(_StoreState) _then) = __$StoreStateCopyWithImpl;
@override @useResult
$Res call({
 StoreView view, List<Product> products, List<BagItem> bagItems, List<PaymentMethod> paymentMethods, String selectedProductId, String selectedPaymentMethodId, bool billingSameAsShipping
});




}
/// @nodoc
class __$StoreStateCopyWithImpl<$Res>
    implements _$StoreStateCopyWith<$Res> {
  __$StoreStateCopyWithImpl(this._self, this._then);

  final _StoreState _self;
  final $Res Function(_StoreState) _then;

/// Create a copy of StoreState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? view = null,Object? products = null,Object? bagItems = null,Object? paymentMethods = null,Object? selectedProductId = null,Object? selectedPaymentMethodId = null,Object? billingSameAsShipping = null,}) {
  return _then(_StoreState(
view: null == view ? _self.view : view // ignore: cast_nullable_to_non_nullable
as StoreView,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,bagItems: null == bagItems ? _self._bagItems : bagItems // ignore: cast_nullable_to_non_nullable
as List<BagItem>,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethod>,selectedProductId: null == selectedProductId ? _self.selectedProductId : selectedProductId // ignore: cast_nullable_to_non_nullable
as String,selectedPaymentMethodId: null == selectedPaymentMethodId ? _self.selectedPaymentMethodId : selectedPaymentMethodId // ignore: cast_nullable_to_non_nullable
as String,billingSameAsShipping: null == billingSameAsShipping ? _self.billingSameAsShipping : billingSameAsShipping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

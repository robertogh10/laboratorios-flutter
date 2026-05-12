// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingStepEntity {

 int get index; String get title; String get subtitle; double get progress;
/// Create a copy of OnboardingStepEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStepEntityCopyWith<OnboardingStepEntity> get copyWith => _$OnboardingStepEntityCopyWithImpl<OnboardingStepEntity>(this as OnboardingStepEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStepEntity&&(identical(other.index, index) || other.index == index)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,index,title,subtitle,progress);

@override
String toString() {
  return 'OnboardingStepEntity(index: $index, title: $title, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $OnboardingStepEntityCopyWith<$Res>  {
  factory $OnboardingStepEntityCopyWith(OnboardingStepEntity value, $Res Function(OnboardingStepEntity) _then) = _$OnboardingStepEntityCopyWithImpl;
@useResult
$Res call({
 int index, String title, String subtitle, double progress
});




}
/// @nodoc
class _$OnboardingStepEntityCopyWithImpl<$Res>
    implements $OnboardingStepEntityCopyWith<$Res> {
  _$OnboardingStepEntityCopyWithImpl(this._self, this._then);

  final OnboardingStepEntity _self;
  final $Res Function(OnboardingStepEntity) _then;

/// Create a copy of OnboardingStepEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? title = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStepEntity].
extension OnboardingStepEntityPatterns on OnboardingStepEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStepEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStepEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStepEntity value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStepEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStepEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStepEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String title,  String subtitle,  double progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStepEntity() when $default != null:
return $default(_that.index,_that.title,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String title,  String subtitle,  double progress)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStepEntity():
return $default(_that.index,_that.title,_that.subtitle,_that.progress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String title,  String subtitle,  double progress)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStepEntity() when $default != null:
return $default(_that.index,_that.title,_that.subtitle,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingStepEntity implements OnboardingStepEntity {
  const _OnboardingStepEntity({required this.index, required this.title, required this.subtitle, required this.progress});
  

@override final  int index;
@override final  String title;
@override final  String subtitle;
@override final  double progress;

/// Create a copy of OnboardingStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStepEntityCopyWith<_OnboardingStepEntity> get copyWith => __$OnboardingStepEntityCopyWithImpl<_OnboardingStepEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStepEntity&&(identical(other.index, index) || other.index == index)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,index,title,subtitle,progress);

@override
String toString() {
  return 'OnboardingStepEntity(index: $index, title: $title, subtitle: $subtitle, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStepEntityCopyWith<$Res> implements $OnboardingStepEntityCopyWith<$Res> {
  factory _$OnboardingStepEntityCopyWith(_OnboardingStepEntity value, $Res Function(_OnboardingStepEntity) _then) = __$OnboardingStepEntityCopyWithImpl;
@override @useResult
$Res call({
 int index, String title, String subtitle, double progress
});




}
/// @nodoc
class __$OnboardingStepEntityCopyWithImpl<$Res>
    implements _$OnboardingStepEntityCopyWith<$Res> {
  __$OnboardingStepEntityCopyWithImpl(this._self, this._then);

  final _OnboardingStepEntity _self;
  final $Res Function(_OnboardingStepEntity) _then;

/// Create a copy of OnboardingStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? title = null,Object? subtitle = null,Object? progress = null,}) {
  return _then(_OnboardingStepEntity(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

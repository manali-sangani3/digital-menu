// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dish_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DishModel {

 String get id; String get name; double get price; String get photoUrl; String get categoryId; int? get createdAt;
/// Create a copy of DishModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DishModelCopyWith<DishModel> get copyWith => _$DishModelCopyWithImpl<DishModel>(this as DishModel, _$identity);

  /// Serializes this DishModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DishModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,photoUrl,categoryId,createdAt);

@override
String toString() {
  return 'DishModel(id: $id, name: $name, price: $price, photoUrl: $photoUrl, categoryId: $categoryId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DishModelCopyWith<$Res>  {
  factory $DishModelCopyWith(DishModel value, $Res Function(DishModel) _then) = _$DishModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double price, String photoUrl, String categoryId, int? createdAt
});




}
/// @nodoc
class _$DishModelCopyWithImpl<$Res>
    implements $DishModelCopyWith<$Res> {
  _$DishModelCopyWithImpl(this._self, this._then);

  final DishModel _self;
  final $Res Function(DishModel) _then;

/// Create a copy of DishModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? photoUrl = null,Object? categoryId = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DishModel].
extension DishModelPatterns on DishModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DishModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DishModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DishModel value)  $default,){
final _that = this;
switch (_that) {
case _DishModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DishModel value)?  $default,){
final _that = this;
switch (_that) {
case _DishModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double price,  String photoUrl,  String categoryId,  int? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DishModel() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.photoUrl,_that.categoryId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double price,  String photoUrl,  String categoryId,  int? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DishModel():
return $default(_that.id,_that.name,_that.price,_that.photoUrl,_that.categoryId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double price,  String photoUrl,  String categoryId,  int? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DishModel() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.photoUrl,_that.categoryId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DishModel extends DishModel {
  const _DishModel({required this.id, required this.name, required this.price, required this.photoUrl, required this.categoryId, this.createdAt}): super._();
  factory _DishModel.fromJson(Map<String, dynamic> json) => _$DishModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  double price;
@override final  String photoUrl;
@override final  String categoryId;
@override final  int? createdAt;

/// Create a copy of DishModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DishModelCopyWith<_DishModel> get copyWith => __$DishModelCopyWithImpl<_DishModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DishModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DishModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,photoUrl,categoryId,createdAt);

@override
String toString() {
  return 'DishModel(id: $id, name: $name, price: $price, photoUrl: $photoUrl, categoryId: $categoryId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DishModelCopyWith<$Res> implements $DishModelCopyWith<$Res> {
  factory _$DishModelCopyWith(_DishModel value, $Res Function(_DishModel) _then) = __$DishModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double price, String photoUrl, String categoryId, int? createdAt
});




}
/// @nodoc
class __$DishModelCopyWithImpl<$Res>
    implements _$DishModelCopyWith<$Res> {
  __$DishModelCopyWithImpl(this._self, this._then);

  final _DishModel _self;
  final $Res Function(_DishModel) _then;

/// Create a copy of DishModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? photoUrl = null,Object? categoryId = null,Object? createdAt = freezed,}) {
  return _then(_DishModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

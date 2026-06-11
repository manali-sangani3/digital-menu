// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DishModel _$DishModelFromJson(Map<String, dynamic> json) => _DishModel(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  photoUrl: json['photoUrl'] as String,
  categoryId: json['categoryId'] as String,
  createdAt: (json['createdAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$DishModelToJson(_DishModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'photoUrl': instance.photoUrl,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt,
    };

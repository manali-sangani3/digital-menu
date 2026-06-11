import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dish.dart';

part 'dish_model.freezed.dart';
part 'dish_model.g.dart';

@freezed
abstract class DishModel with _$DishModel {
  const factory DishModel({
    required String id,
    required String name,
    required double price,
    required String photoUrl,
    required String categoryId,
    int? createdAt,
  }) = _DishModel;

  factory DishModel.fromJson(Map<String, dynamic> json) =>
      _$DishModelFromJson(json);

  factory DishModel.fromEntity(Dish entity) => DishModel(
        id: entity.id,
        name: entity.name,
        price: entity.price,
        photoUrl: entity.photoUrl,
        categoryId: entity.categoryId,
        createdAt: entity.createdAt,
      );

  const DishModel._();

  Dish toEntity() => Dish(
        id: id,
        name: name,
        price: price,
        photoUrl: photoUrl,
        categoryId: categoryId,
        createdAt: createdAt,
      );
}

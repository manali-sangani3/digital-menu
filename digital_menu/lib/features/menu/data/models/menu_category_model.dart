import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/menu_category.dart';

part 'menu_category_model.freezed.dart';
part 'menu_category_model.g.dart';

@freezed
abstract class MenuCategoryModel with _$MenuCategoryModel {
  const factory MenuCategoryModel({
    required String id,
    required String name,
  }) = _MenuCategoryModel;

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryModelFromJson(json);

  factory MenuCategoryModel.fromEntity(MenuCategory entity) =>
      MenuCategoryModel(id: entity.id, name: entity.name);

  const MenuCategoryModel._();

  MenuCategory toEntity() => MenuCategory(id: id, name: name);
}

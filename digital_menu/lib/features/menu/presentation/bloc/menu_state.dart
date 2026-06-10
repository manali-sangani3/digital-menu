import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/entities/dish.dart';

part 'menu_state.freezed.dart';

@freezed
abstract class MenuState with _$MenuState {
  const factory MenuState({
    @Default([]) List<MenuCategory> categories,
    @Default([]) List<Dish> dishes,
    @Default(false) bool isLoadingCategories,
    @Default(false) bool isLoadingDishes,
    String? selectedCategoryId,
    String? errorMessage,
  }) = _MenuState;
}

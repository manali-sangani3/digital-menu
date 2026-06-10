import '../../../../core/network/cloud_result.dart';
import '../entities/menu_category.dart';
import '../entities/dish.dart';

abstract class MenuRepository {
  Stream<CloudResult<List<MenuCategory>>> streamCategories();
  Stream<CloudResult<List<Dish>>> streamDishesByCategory(String categoryId);
}

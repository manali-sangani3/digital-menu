import '../../../../core/network/cloud_result.dart';
import '../entities/menu_category.dart';
import '../repositories/menu_repository.dart';

class GetCategoriesUseCase {
  final MenuRepository _repository;

  GetCategoriesUseCase(this._repository);

  Stream<CloudResult<List<MenuCategory>>> call() {
    return _repository.streamCategories();
  }
}

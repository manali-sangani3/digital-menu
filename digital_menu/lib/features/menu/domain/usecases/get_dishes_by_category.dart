import '../../../../core/network/cloud_result.dart';
import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class GetDishesByCategoryUseCase {
  final MenuRepository _repository;

  GetDishesByCategoryUseCase(this._repository);

  Stream<CloudResult<List<Dish>>> call(String categoryId) {
    return _repository.streamDishesByCategory(categoryId);
  }
}

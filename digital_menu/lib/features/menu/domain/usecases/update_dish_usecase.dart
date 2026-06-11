import '../../../../core/network/cloud_result.dart';
import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class UpdateDishUseCase {
  final MenuRepository _repository;

  UpdateDishUseCase(this._repository);

  Future<CloudResult<void>> call(Dish dish) {
    return _repository.updateDish(dish);
  }
}

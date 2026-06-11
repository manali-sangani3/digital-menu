import '../../../../core/network/cloud_result.dart';
import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class AddDishUseCase {
  final MenuRepository _repository;

  AddDishUseCase(this._repository);

  Future<CloudResult<void>> call(Dish dish) {
    return _repository.addDish(dish);
  }
}

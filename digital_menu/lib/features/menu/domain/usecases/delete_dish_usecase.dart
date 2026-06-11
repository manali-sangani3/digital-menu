import '../../../../core/network/cloud_result.dart';
import '../repositories/menu_repository.dart';

class DeleteDishUseCase {
  final MenuRepository _repository;

  DeleteDishUseCase(this._repository);

  Future<CloudResult<void>> call(String dishId) {
    return _repository.deleteDish(dishId);
  }
}

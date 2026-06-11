import 'dart:typed_data';
import '../../../../core/network/cloud_result.dart';
import '../repositories/menu_repository.dart';

class UploadDishImageUseCase {
  final MenuRepository _repository;

  UploadDishImageUseCase(this._repository);

  Future<CloudResult<String>> call(String fileName, Uint8List fileBytes) {
    return _repository.uploadImage(fileName, fileBytes);
  }
}

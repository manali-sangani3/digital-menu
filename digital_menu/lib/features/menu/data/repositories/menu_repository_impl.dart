import 'dart:async';
import 'dart:typed_data';
import '../../../../core/network/cloud_result.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/entities/dish.dart';
import '../datasources/menu_remote_datasource.dart';
import '../models/dish_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;

  MenuRepositoryImpl(this._remoteDataSource);

  @override
  Stream<CloudResult<List<MenuCategory>>> streamCategories() {
    return _remoteDataSource.streamCategories().map<CloudResult<List<MenuCategory>>>(
      (categoryModels) {
        final categories = categoryModels.map((m) => m.toEntity()).toList();
        return CloudResult(
          statusCode: 200,
          data: categories,
          message: 'Categories streamed successfully.',
        );
      },
    ).handleError(
      (error) {
        return CloudResult<List<MenuCategory>>(
          statusCode: 500,
          message: 'Error streaming categories: $error',
        );
      },
    );
  }

  @override
  Stream<CloudResult<List<Dish>>> streamDishesByCategory(String categoryId) {
    return _remoteDataSource.streamDishesByCategory(categoryId).map<CloudResult<List<Dish>>>(
      (dishModels) {
        final dishes = dishModels.map((m) => m.toEntity()).toList();
        return CloudResult(
          statusCode: 200,
          data: dishes,
          message: 'Dishes streamed successfully.',
        );
      },
    ).handleError(
      (error) {
        return CloudResult<List<Dish>>(
          statusCode: 500,
          message: 'Error streaming dishes: $error',
        );
      },
    );
  }

  @override
  Future<CloudResult<void>> addDish(Dish dish) async {
    try {
      final model = DishModel.fromEntity(dish);
      await _remoteDataSource.addDish(model);
      return const CloudResult(
        statusCode: 200,
        message: 'Dish added successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error adding dish: $e',
      );
    }
  }

  @override
  Future<CloudResult<String>> uploadImage(String fileName, Uint8List fileBytes) async {
    try {
      final url = await _remoteDataSource.uploadImage(fileName, fileBytes);
      return CloudResult(
        statusCode: 200,
        data: url,
        message: 'Image uploaded successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error uploading image: $e',
      );
    }
  }

  @override
  Future<CloudResult<void>> updateDish(Dish dish) async {
    try {
      final model = DishModel.fromEntity(dish);
      await _remoteDataSource.updateDish(model);
      return const CloudResult(
        statusCode: 200,
        message: 'Dish updated successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error updating dish: $e',
      );
    }
  }

  @override
  Future<CloudResult<void>> deleteDish(String dishId) async {
    try {
      await _remoteDataSource.deleteDish(dishId);
      return const CloudResult(
        statusCode: 200,
        message: 'Dish deleted successfully.',
      );
    } catch (e) {
      return CloudResult(
        statusCode: 500,
        message: 'Error deleting dish: $e',
      );
    }
  }
}

import 'dart:async';
import '../../../../core/network/cloud_result.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/entities/dish.dart';
import '../datasources/menu_remote_datasource.dart';

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
}

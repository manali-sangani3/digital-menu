import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/constants.dart';
import '../models/menu_category_model.dart';
import '../models/dish_model.dart';

abstract class MenuRemoteDataSource {
  Stream<List<MenuCategoryModel>> streamCategories();
  Stream<List<DishModel>> streamDishesByCategory(String categoryId);
  Future<void> addDish(DishModel dish);
  Future<String> uploadImage(String fileName, Uint8List fileBytes);
  Future<void> updateDish(DishModel dish);
  Future<void> deleteDish(String dishId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final FirebaseFirestore _firestore;

  MenuRemoteDataSourceImpl(this._firestore);

  CollectionReference<MenuCategoryModel> get _categoriesRef => _firestore
      .collection(FirestoreCollections.categories)
      .withConverter<MenuCategoryModel>(
        fromFirestore: (snapshot, _) => MenuCategoryModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  CollectionReference<DishModel> get _dishesRef => _firestore
      .collection(FirestoreCollections.dishes)
      .withConverter<DishModel>(
        fromFirestore: (snapshot, _) => DishModel.fromJson(
          (snapshot.data() ?? {})..putIfAbsent('id', () => snapshot.id),
        ),
        toFirestore: (model, _) => model.toJson()..remove('id'),
      );

  @override
  Stream<List<MenuCategoryModel>> streamCategories() {
    return _categoriesRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  @override
  Stream<List<DishModel>> streamDishesByCategory(String categoryId) {
    return _dishesRef
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) => doc.data()).toList();
      list.sort((a, b) {
        final aTime = a.createdAt ?? 0;
        final bTime = b.createdAt ?? 0;
        return aTime.compareTo(bTime);
      });
      return list;
    });
  }

  @override
  Future<void> addDish(DishModel dish) async {
    await _dishesRef.add(dish);
  }

  @override
  Future<String> uploadImage(String fileName, Uint8List fileBytes) async {
    final extension = fileName.split('.').last.toLowerCase();
    final base64Str = base64Encode(fileBytes);
    return 'data:image/$extension;base64,$base64Str';
  }

  @override
  Future<void> updateDish(DishModel dish) async {
    await _dishesRef.doc(dish.id).set(dish);
  }

  @override
  Future<void> deleteDish(String dishId) async {
    await _dishesRef.doc(dishId).delete();
  }
}

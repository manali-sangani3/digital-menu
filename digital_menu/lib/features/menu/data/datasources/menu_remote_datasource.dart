import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/constants.dart';
import '../models/menu_category_model.dart';
import '../models/dish_model.dart';

abstract class MenuRemoteDataSource {
  Stream<List<MenuCategoryModel>> streamCategories();
  Stream<List<DishModel>> streamDishesByCategory(String categoryId);
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
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

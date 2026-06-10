import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/constants.dart';

class DatabaseSeeder {
  static Future<void> seedIfEmpty() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Check if categories collection is empty
      final categoriesSnap = await firestore
          .collection(FirestoreCollections.categories)
          .limit(1)
          .get();

      if (categoriesSnap.docs.isNotEmpty) {
        // Database is already seeded
        return;
      }

      // Seed Categories
      final breakfastRef = firestore.collection(FirestoreCollections.categories).doc();
      final drinksRef = firestore.collection(FirestoreCollections.categories).doc();
      final dessertsRef = firestore.collection(FirestoreCollections.categories).doc();

      await breakfastRef.set({'name': 'Breakfast'});
      await drinksRef.set({'name': 'Drinks'});
      await dessertsRef.set({'name': 'Desserts'});

      final breakfastId = breakfastRef.id;
      final drinksId = drinksRef.id;
      final dessertsId = dessertsRef.id;

      // Seed Dishes (Minimum 5 dishes with photos)
      final dishes = [
        {
          'name': 'Avocado Toast',
          'price': 180.0,
          'photoUrl': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500',
          'categoryId': breakfastId,
        },
        {
          'name': 'Pancakes',
          'price': 220.0,
          'photoUrl': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500',
          'categoryId': breakfastId,
        },
        {
          'name': 'Espresso',
          'price': 120.0,
          'photoUrl': 'https://images.unsplash.com/photo-151097252790b-af4f42d91010?w=500',
          'categoryId': drinksId,
        },
        {
          'name': 'Flat White',
          'price': 160.0,
          'photoUrl': 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=500',
          'categoryId': drinksId,
        },
        {
          'name': 'Chocolate Brownie',
          'price': 150.0,
          'photoUrl': 'https://images.unsplash.com/photo-1564355808539-22fda35bed7e?w=500',
          'categoryId': dessertsId,
        },
      ];

      for (final dish in dishes) {
        await firestore.collection(FirestoreCollections.dishes).add(dish);
      }
    } catch (e) {
      // Fail silently to prevent app crash on seed failure (e.g. permission issues)
    }
  }
}

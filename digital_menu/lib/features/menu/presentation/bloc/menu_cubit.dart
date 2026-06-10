import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_dishes_by_category.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetDishesByCategoryUseCase _getDishesByCategoryUseCase;

  StreamSubscription? _categoriesSubscription;
  StreamSubscription? _dishesSubscription;

  MenuCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetDishesByCategoryUseCase getDishesByCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _getDishesByCategoryUseCase = getDishesByCategoryUseCase,
        super(const MenuState());

  void loadMenu() {
    emit(state.copyWith(isLoadingCategories: true, errorMessage: null));

    _categoriesSubscription?.cancel();
    _categoriesSubscription = _getCategoriesUseCase().listen(
      (result) {
        if (result.isSuccess && result.data != null) {
          final categories = result.data!;
          emit(state.copyWith(
            categories: categories,
            isLoadingCategories: false,
          ));

          // Auto-select first category if available and no category is currently selected
          if (categories.isNotEmpty && state.selectedCategoryId == null) {
            selectCategory(categories.first.id);
          }
        } else {
          emit(state.copyWith(
            isLoadingCategories: false,
            errorMessage: result.message,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          isLoadingCategories: false,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  void selectCategory(String categoryId) {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      isLoadingDishes: true,
      errorMessage: null,
    ));

    _dishesSubscription?.cancel();
    _dishesSubscription = _getDishesByCategoryUseCase(categoryId).listen(
      (result) {
        if (result.isSuccess && result.data != null) {
          emit(state.copyWith(
            dishes: result.data!,
            isLoadingDishes: false,
          ));
        } else {
          emit(state.copyWith(
            isLoadingDishes: false,
            errorMessage: result.message,
          ));
        }
      },
      onError: (error) {
        emit(state.copyWith(
          isLoadingDishes: false,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    _dishesSubscription?.cancel();
    return super.close();
  }
}

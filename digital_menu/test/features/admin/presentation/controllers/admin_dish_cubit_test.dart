import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:digital_menu/core/network/cloud_result.dart';
import 'package:digital_menu/features/menu/domain/entities/dish.dart';
import 'package:digital_menu/features/menu/domain/usecases/add_dish_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/upload_dish_image_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/update_dish_usecase.dart';
import 'package:digital_menu/features/menu/domain/usecases/delete_dish_usecase.dart';
import 'package:digital_menu/features/admin/presentation/controllers/admin_dish_cubit.dart';
import 'package:digital_menu/features/admin/presentation/controllers/admin_dish_state.dart';

class MockAddDishUseCase extends Mock implements AddDishUseCase {}
class MockUploadDishImageUseCase extends Mock implements UploadDishImageUseCase {}
class MockUpdateDishUseCase extends Mock implements UpdateDishUseCase {}
class MockDeleteDishUseCase extends Mock implements DeleteDishUseCase {}

class FakeDish extends Fake implements Dish {}

void main() {
  late AdminDishCubit cubit;
  late MockAddDishUseCase mockAddDishUseCase;
  late MockUploadDishImageUseCase mockUploadDishImageUseCase;
  late MockUpdateDishUseCase mockUpdateDishUseCase;
  late MockDeleteDishUseCase mockDeleteDishUseCase;

  setUpAll(() {
    registerFallbackValue(FakeDish());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockAddDishUseCase = MockAddDishUseCase();
    mockUploadDishImageUseCase = MockUploadDishImageUseCase();
    mockUpdateDishUseCase = MockUpdateDishUseCase();
    mockDeleteDishUseCase = MockDeleteDishUseCase();

    cubit = AdminDishCubit(
      addDishUseCase: mockAddDishUseCase,
      uploadDishImageUseCase: mockUploadDishImageUseCase,
      updateDishUseCase: mockUpdateDishUseCase,
      deleteDishUseCase: mockDeleteDishUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('editDish', () {
    blocTest<AdminDishCubit, AdminDishState>(
      'emits [loading, success] when editing a dish without changing the photo succeeds',
      build: () {
        when(() => mockUpdateDishUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 200,
            message: 'Success',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.editDish(
        id: 'dish123',
        name: 'Test Dish Updated',
        price: 180.0,
        categoryId: 'cat123',
        existingPhotoUrl: 'data:image/png;base64,abcdef',
      ),
      expect: () => const [
        AdminDishState.loading(),
        AdminDishState.success(),
      ],
      verify: (_) {
        verify(() => mockUpdateDishUseCase.call(any())).called(1);
      },
    );

    blocTest<AdminDishCubit, AdminDishState>(
      'emits [loading, success] when editing a dish with a new photo succeeds',
      build: () {
        when(() => mockUploadDishImageUseCase.call(any(), any())).thenAnswer(
          (_) async => const CloudResult<String>(
            statusCode: 200,
            data: 'data:image/jpeg;base64,newphoto',
            message: 'Success',
          ),
        );
        when(() => mockUpdateDishUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 200,
            message: 'Success',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.editDish(
        id: 'dish123',
        name: 'Test Dish Updated',
        price: 180.0,
        categoryId: 'cat123',
        fileName: 'new_image.jpg',
        fileBytes: Uint8List(0),
        existingPhotoUrl: 'data:image/png;base64,abcdef',
      ),
      expect: () => const [
        AdminDishState.loading(),
        AdminDishState.success(),
      ],
      verify: (_) {
        verify(() => mockUploadDishImageUseCase.call('new_image.jpg', any())).called(1);
        verify(() => mockUpdateDishUseCase.call(any())).called(1);
      },
    );

    blocTest<AdminDishCubit, AdminDishState>(
      'emits [loading, error] when update usecase fails',
      build: () {
        when(() => mockUpdateDishUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 500,
            message: 'Failed to update in Firestore',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.editDish(
        id: 'dish123',
        name: 'Test Dish Updated',
        price: 180.0,
        categoryId: 'cat123',
        existingPhotoUrl: 'data:image/png;base64,abcdef',
      ),
      expect: () => const [
        AdminDishState.loading(),
        AdminDishState.error('Failed to update in Firestore'),
      ],
    );
  });

  group('deleteDish', () {
    blocTest<AdminDishCubit, AdminDishState>(
      'emits [loading, success] when deleting a dish succeeds',
      build: () {
        when(() => mockDeleteDishUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 200,
            message: 'Success',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.deleteDish('dish123'),
      expect: () => const [
        AdminDishState.loading(),
        AdminDishState.success(),
      ],
      verify: (_) {
        verify(() => mockDeleteDishUseCase.call('dish123')).called(1);
      },
    );

    blocTest<AdminDishCubit, AdminDishState>(
      'emits [loading, error] when deleting a dish fails',
      build: () {
        when(() => mockDeleteDishUseCase.call(any())).thenAnswer(
          (_) async => const CloudResult<void>(
            statusCode: 400,
            message: 'Firestore delete error',
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.deleteDish('dish123'),
      expect: () => const [
        AdminDishState.loading(),
        AdminDishState.error('Firestore delete error'),
      ],
    );
  });
}

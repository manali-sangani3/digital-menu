import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dish_state.freezed.dart';

@freezed
abstract class AdminDishState with _$AdminDishState {
  const factory AdminDishState.initial() = _Initial;
  const factory AdminDishState.loading() = _Loading;
  const factory AdminDishState.success() = _Success;
  const factory AdminDishState.error(String message) = _Error;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:digital_menu/app.dart';
import 'package:digital_menu/features/admin/presentation/controllers/auth_cubit.dart';
import 'package:digital_menu/features/admin/presentation/controllers/auth_state.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() {
    final mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.state).thenReturn(const AuthState(status: AuthStatus.unauthenticated));
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream<AuthState>.empty());
    
    sl.registerLazySingleton<AuthCubit>(() => mockAuthCubit);
  });

  tearDownAll(() {
    sl.reset();
  });

  testWidgets('Smoke test for digital menu main page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DigitalMenuApp());

    // Verify that the initial customer view renders.
    expect(find.text('Café Digital Menu'), findsOneWidget);
    expect(find.text('Non-existent text'), findsNothing);
  });
}

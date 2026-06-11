import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';
import 'core/di/di.dart';
import 'features/admin/presentation/controllers/auth_cubit.dart';

class DigitalMenuApp extends StatelessWidget {
  final String? initError;

  const DigitalMenuApp({
    super.key,
    this.initError,
  });

  @override
  Widget build(BuildContext context) {
    if (initError != null) {
      return MaterialApp(
        title: 'Digital Menu - Error',
        theme: CafeTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Initialization Error',
                    style: CafeTheme.lightTheme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    initError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: MaterialApp.router(
        title: 'Digital Menu',
        theme: CafeTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


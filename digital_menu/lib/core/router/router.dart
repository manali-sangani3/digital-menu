import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/di.dart';
import '../../features/menu/presentation/pages/home_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/admin/presentation/pages/admin_page.dart';
import '../../features/admin/presentation/pages/admin_login_page.dart';
import '../../features/admin/presentation/controllers/auth_cubit.dart';
import '../../features/admin/presentation/controllers/auth_state.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
  redirect: (context, state) {
    final authCubit = sl<AuthCubit>();
    final authStatus = authCubit.state.status;
    final isAuthenticated = authStatus == AuthStatus.authenticated;
    final isLoggingIn = state.matchedLocation == '/admin/login';

    // While checking initial auth state, wait and don't redirect
    if (authStatus == AuthStatus.initial) {
      return null;
    }

    // If trying to access admin pages and not authenticated, redirect to login
    if (state.matchedLocation.startsWith('/admin') && !isLoggingIn && !isAuthenticated) {
      return '/admin/login';
    }

    // If authenticated and trying to access login, redirect to admin
    if (isLoggingIn && isAuthenticated) {
      return '/admin';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPage(),
    ),
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginPage(),
    ),
  ],
);

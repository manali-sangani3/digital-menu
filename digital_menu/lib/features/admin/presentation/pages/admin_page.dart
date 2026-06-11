import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../menu/presentation/bloc/menu_cubit.dart';
import '../../../menu/presentation/bloc/menu_state.dart';
import '../controllers/auth_cubit.dart';
import '../controllers/auth_state.dart';
import '../controllers/admin_dish_cubit.dart';
import '../controllers/admin_dish_state.dart';
import '../widgets/add_dish_dialog.dart';
import '../widgets/admin_dish_card.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthStatus.initial ||
            authState.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider<MenuCubit>(
              create: (context) => sl<MenuCubit>()..loadMenu(),
            ),
            BlocProvider<AdminDishCubit>(
              create: (context) => sl<AdminDishCubit>(),
            ),
          ],
          child: const AdminPageView(),
        );
      },
    );
  }
}

class AdminPageView extends StatelessWidget {
  const AdminPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;
    final email = authState.user?.email ?? 'Admin';

    return BlocListener<AdminDishCubit, AdminDishState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Operation completed successfully.'),
                backgroundColor: Colors.green,
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey[200],
              height: 1.0,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Sign Out',
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8F0),
                Color(0xFFFAF0E6),
              ],
            ),
          ),
          child: BlocBuilder<MenuCubit, MenuState>(
            builder: (context, menuState) {
              if (menuState.isLoadingCategories) {
                return const Center(child: CircularProgressIndicator());
              }

              if (menuState.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${menuState.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<MenuCubit>().loadMenu(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Menu Management',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add and view dishes by category',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => BlocProvider<AdminDishCubit>(
                                create: (_) => sl<AdminDishCubit>(),
                                child: AddDishDialog(categories: menuState.categories),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add Dish'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (menuState.categories.isEmpty)
                      const Center(child: Text('No categories available.'))
                    else ...[
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: menuState.categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final category = menuState.categories[index];
                            final isSelected = category.id == menuState.selectedCategoryId;
                            return ChoiceChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<MenuCubit>().selectCategory(category.id);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: menuState.isLoadingDishes
                            ? const Center(child: CircularProgressIndicator())
                            : menuState.dishes.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.restaurant_menu_rounded,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No items available in this category',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 220,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: menuState.dishes.length,
                                    itemBuilder: (context, index) {
                                      final dish = menuState.dishes[index];
                                      return AdminDishCard(
                                        dish: dish,
                                        onEdit: () {
                                          showDialog<bool>(
                                            context: context,
                                            builder: (dialogContext) => BlocProvider<AdminDishCubit>(
                                              create: (_) => sl<AdminDishCubit>(),
                                              child: AddDishDialog(
                                                categories: menuState.categories,
                                                dish: dish,
                                              ),
                                            ),
                                          );
                                        },
                                        onDelete: () {
                                          final adminDishCubit = context.read<AdminDishCubit>();
                                          showDialog<bool>(
                                            context: context,
                                            builder: (dialogContext) => AlertDialog(
                                              title: const Text('Delete Dish'),
                                              content: Text('Are you sure you want to delete "${dish.name}"?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(dialogContext, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(dialogContext, true),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ).then((confirmed) {
                                            if (confirmed == true) {
                                              adminDishCubit.deleteDish(dish.id);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

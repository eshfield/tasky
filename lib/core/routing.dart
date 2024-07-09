import 'package:app/core/di/dependency_container.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/presentation/screens/app_init_error_screen.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:app/presentation/screens/task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home(name: 'home', path: '/'),
  task(name: 'task', path: 'task'),
  appInitFailure(name: 'app-init-failure', path: '/app-init-failure');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

final routerConfig = GoRouter(
  initialLocation: AppRoute.home.path,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final dependencyContainer = context.read<DependencyContainer>();
    return dependencyContainer.isInitializedSuccessfully
        ? null
        : state.namedLocation(AppRoute.appInitFailure.name);
  },
  routes: [
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.path,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          name: AppRoute.task.name,
          path: AppRoute.task.path,
          builder: (context, state) => TaskScreen(state.extra as Task?),
        ),
      ],
    ),
    GoRoute(
      name: AppRoute.appInitFailure.name,
      path: AppRoute.appInitFailure.path,
      builder: (context, state) => const AppInitErrorScreen(),
    ),
  ],
);

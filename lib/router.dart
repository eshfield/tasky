import 'package:app/domain/models/task.dart';
import 'package:app/presentation/app_init_status_screen/app_init_status_screen.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/task_screen/task_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home(name: 'home', path: '/'),
  task(name: 'task', path: 'task');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

final loadingConfig = RoutingConfig(
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const AppInitStatusScreen(),
    ),
  ],
);

final successConfig = RoutingConfig(
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
  ],
);

final failureConfig = RoutingConfig(
  routes: [
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => const AppInitStatusScreen(isError: true),
    ),
  ],
);

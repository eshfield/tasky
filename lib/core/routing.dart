import 'package:app/domain/bloc/app_init_cubit.dart';
import 'package:app/domain/entities/task.dart';
import 'package:app/presentation/screens/app_init_screen.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:app/presentation/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home(name: 'home', path: '/'),
  task(name: 'task', path: 'task'),
  appInitLoading(name: 'app-init-loading', path: '/app-init-loading'),
  appInitFailure(name: 'app-init-failure', path: '/app-init-failure');

  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

String? _pathBeforeRedirect;

final routerConfig = GoRouter(
  initialLocation: AppRoute.home.path,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final appInitCubit = context.read<AppInitCubit>();
    switch (appInitCubit.state.status) {
      case AppInitStatus.loading:
        if (state.fullPath == AppRoute.appInitLoading.path) return null;
        _pathBeforeRedirect = state.fullPath;
        return state.namedLocation(AppRoute.appInitLoading.name);
      case AppInitStatus.success:
        if (_pathBeforeRedirect != null) {
          final path = _pathBeforeRedirect;
          _pathBeforeRedirect = null;
          return path!;
        }
        return null;
      case AppInitStatus.failure:
        return state.namedLocation(AppRoute.appInitFailure.name);
    }
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
      name: AppRoute.appInitLoading.name,
      path: AppRoute.appInitLoading.path,
      builder: _appInitBuilder,
    ),
    GoRoute(
      name: AppRoute.appInitFailure.name,
      path: AppRoute.appInitFailure.path,
      builder: _appInitBuilder,
    ),
  ],
);

Widget _appInitBuilder(BuildContext context, GoRouterState state) {
  final appInitCubit = context.read<AppInitCubit>();
  return AppInitScreen(appInitCubit.state.status);
}

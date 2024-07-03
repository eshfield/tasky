import 'package:app/domain/bloc/app_init_cubit.dart';
import 'package:app/presentation/theme/theme.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routingConfig = ValueNotifier(const RoutingConfig(routes: []));
    return BlocProvider(
      create: (context) => AppInitCubit(),
      child: BlocBuilder<AppInitCubit, AppInitState>(
        builder: (context, state) {
          routingConfig.value = switch (state.status) {
            AppInitStatus.loading => loadingConfig,
            AppInitStatus.success => successConfig,
            AppInitStatus.failure => failureConfig,
          };
          return MaterialApp.router(
            darkTheme: AppTheme.dark,
            theme: AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: GoRouter.routingConfig(routingConfig: routingConfig),
            title: 'Tasky',
          );
        },
      ),
    );
  }
}

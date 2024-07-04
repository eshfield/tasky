import 'package:app/domain/bloc/app_init_cubit.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/theme/theme.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppInitCubit(),
      child: BlocListener<AppInitCubit, AppInitState>(
        listener: (context, state) => routerConfig.refresh(),
        child: MaterialApp.router(
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: routerConfig,
          onGenerateTitle: (context) => context.l10n.appTitle,
        ),
      ),
    );
  }
}

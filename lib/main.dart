import 'package:app/core/di/dependency_container.dart';
import 'package:app/core/di/remote_config.dart';
import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencyContainer = await AppDependencyContainer.create();
  runApp(App(dependencyContainer));
}

class App extends StatelessWidget {
  final DependencyContainer dependencyContainer;

  const App(this.dependencyContainer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: dependencyContainer,
      child: RemoteConfig(
        remoteConfig: dependencyContainer.remoteConfig,
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

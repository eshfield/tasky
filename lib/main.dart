import 'package:app/core/di/dependency_container.dart';
import 'package:app/core/di/remote_config.dart';
import 'package:app/core/extensions/l10n.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/routing.dart';
import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
    return true;
  };
  await FirebaseRemoteConfig.instance.fetchAndActivate();

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

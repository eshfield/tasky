import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/theme/theme.dart';
import 'package:app/presentation/widgets/app_error.dart';
import 'package:app/presentation/widgets/app_loader.dart';
import 'package:app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future _future;

  @override
  void initState() {
    super.initState();
    _future = initDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        late final Widget home;
        if (snapshot.hasData) {
          home = const HomeScreen();
        } else if (snapshot.hasError) {
          Logger().e(snapshot.error, stackTrace: snapshot.stackTrace);
          home = const AppInitErrorScreen();
        } else {
          home = const AppLoader();
        }
        return MaterialApp(
          darkTheme: AppTheme.dark,
          home: home,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          title: 'Tasky',
        );
      },
    );
  }
}

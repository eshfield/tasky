import 'package:app/data/repositories/api_repository.dart';
import 'package:app/data/services/network_status.dart';
import 'package:app/data/sources/local_storage.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/presentation/home_screen/home_screen.dart';
import 'package:app/presentation/theme/theme.dart';
import 'package:app/utils/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(prefs);
  final apiRepository = ApiRepository(localStorage);
  final networkStatus = NetworkStatus();
  await networkStatus.init();
  final deviceId = await getDeviceId();
  runApp(MainApp(
    localStorage,
    apiRepository,
    networkStatus,
    deviceId,
  ));
}

class MainApp extends StatelessWidget {
  final LocalStorage localStorage;
  final ApiRepository apiRepository;
  final NetworkStatus networkStatus;
  final String deviceId;

  const MainApp(
    this.localStorage,
    this.apiRepository,
    this.networkStatus,
    this.deviceId, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TasksCubit()),
        BlocProvider(create: (context) => SyncBloc(apiRepository)),
        ChangeNotifierProvider(create: (context) => networkStatus),
        Provider(create: (context) => deviceId),
      ],
      child: RepositoryProvider(
        create: (context) => BlocDispatcher(
          tasksCubit: context.read<TasksCubit>(),
          syncBloc: context.read<SyncBloc>(),
          localStorage: localStorage,
          networkStatus: networkStatus,
        )..init(),
        lazy: false,
        child: MaterialApp(
          darkTheme: AppTheme.dark,
          home: const HomeScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          title: 'Tasky',
        ),
      ),
    );
  }
}

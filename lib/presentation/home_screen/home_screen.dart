import 'package:app/constants.dart';
import 'package:app/data/services/network_status.dart';
import 'package:app/domain/bloc/bloc_dispatcher.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/widgets/tasks_visibility_button.dart';
import 'package:app/presentation/home_screen/widgets/header.dart';
import 'package:app/presentation/home_screen/widgets/task_list.dart';
import 'package:app/presentation/widgets/app_error.dart';
import 'package:app/presentation/widgets/app_loader.dart';
import 'package:app/presentation/widgets/app_snack_bar.dart';
import 'package:app/presentation/widgets/app_top_bar.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static HomeScreenState of(BuildContext context) =>
      _HomeScreenInheritedWidget.of(context).state;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  var showAppBar = false;
  final networkStatus = GetIt.I<NetworkStatus>();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
    networkStatus.addListener(_handleNetworkNotifications);
  }

  void _handleScroll() {
    final offset = scrollController.offset;
    if (offset > appTopBarHeight && !showAppBar) {
      setState(() {
        showAppBar = true;
      });
    }
    if (offset < appTopBarHeight && showAppBar) {
      setState(() {
        showAppBar = false;
      });
    }
  }

  void _handleNetworkNotifications() {
    showAppSnackBar(
      context,
      text: networkStatus.isOnline
          ? context.l10n.onlineSnackBar
          : context.l10n.offlineSnackBar,
      backgroundColor: networkStatus.isOnline
          ? context.appColors.green
          : context.appColors.gray,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _HomeScreenInheritedWidget(
      state: this,
      child: Scaffold(
        backgroundColor: context.appColors.backPrimary,
        body: SafeArea(
          child: Stack(
            children: [
              const _Content(),
              _TopBar(showAppBar),
            ],
          ),
        ),
        floatingActionButton: const _Fab(),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class _HomeScreenInheritedWidget extends InheritedWidget {
  final HomeScreenState state;

  const _HomeScreenInheritedWidget({
    required this.state,
    required super.child,
  });

  static _HomeScreenInheritedWidget of(BuildContext context) =>
      maybeOf(context) ??
      (throw Exception(
          '$_HomeScreenInheritedWidget was not found in the context'));

  static _HomeScreenInheritedWidget? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _HomeScreenInheritedWidget oldWidget) =>
      true;
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: HomeScreen.of(context).scrollController,
      slivers: [
        const SliverToBoxAdapter(
          child: Header(),
        ),
        BlocListener<SyncBloc, SyncState>(
          bloc: GetIt.I<SyncBloc>(),
          listener: (context, state) {
            showAppSnackBar(
              context,
              text: context.l10n.syncError,
              backgroundColor: context.appColors.red,
            );
          },
          listenWhen: (_, state) => state is SyncFailure,
          child: BlocBuilder<TasksCubit, TasksState>(
            bloc: GetIt.I<TasksCubit>(),
            builder: (context, state) {
              if (state.isInitialized) {
                final tasksToDisplay = state.tasksToDisplay;
                return tasksToDisplay.isEmpty
                    ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _Empty(),
                      )
                    : TaskList(tasksToDisplay);
              }
              return const _InitialLoadingContent();
            },
          ),
        ),
      ],
    );
  }
}

class _InitialLoadingContent extends StatelessWidget {
  const _InitialLoadingContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncState>(
      bloc: GetIt.I<SyncBloc>(),
      builder: (context, state) {
        return switch (state) {
          GetTasksInProgress() => const SliverFillRemaining(
              hasScrollBody: false,
              child: AppLoader(),
            ),
          GetTasksFailure() => SliverFillRemaining(
              hasScrollBody: false,
              child: AppError(
                onPressed: GetIt.I<BlocDispatcher>().init,
              ),
            ),
          _ => const SliverToBoxAdapter(),
        };
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool showAppBar;

  const _TopBar(this.showAppBar);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: showAppBar ? 0 : -appTopBarHeight,
      left: 0,
      right: 0,
      curve: appCurve,
      duration: appTopBarAnimationDuration,
      child: AnimatedOpacity(
        opacity: showAppBar ? 1 : 0,
        curve: appCurve,
        duration: appTopBarAnimationDuration,
        child: AppTopBar(
          title: context.l10n.appTitle,
          trailing: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: TasksVisibilityButton(),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: BlocBuilder<TasksCubit, TasksState>(
          bloc: GetIt.I<TasksCubit>(),
          builder: (context, state) {
            return Text(
              state.showDoneTasks
                  ? context.l10n.noTasks
                  : context.l10n.onlyDoneTasksLeft,
              style: context.appTextStyles.subhead.copyWith(
                color: context.appColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton(
        backgroundColor: context.appColors.blue,
        onPressed: () => context.goNamed(AppRoute.task.name),
        tooltip: context.l10n.addTaskTooltip,
        child: Icon(
          Icons.add,
          color: context.appColors.white,
        ),
      ),
    );
  }
}

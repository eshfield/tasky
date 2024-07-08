import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/core/extensions/l10n_extension.dart';
import 'package:app/presentation/screens/home_screen/home_screen.dart';
import 'package:app/presentation/screens/home_screen/widgets/tasks_visibility_button.dart';
import 'package:app/core/extensions/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 124,
      padding: const EdgeInsets.only(left: 60, right: 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _Title()),
              SizedBox(width: 16),
              _SyncIcon(),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _DoneTasksCounter()),
              SizedBox(width: 16),
              TasksVisibilityButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.homeTitle,
      style: context.appTextStyles.titleLarge.copyWith(
        color: context.appColors.labelPrimary,
      ),
    );
  }
}

class _SyncIcon extends StatelessWidget {
  const _SyncIcon();

  @override
  Widget build(BuildContext context) {
    final networkStatus = HomeScreen.of(context).networkStatus;
    return ListenableBuilder(
      listenable: networkStatus,
      builder: (context, child) {
        return BlocBuilder<SyncBloc, SyncState>(
          bloc: HomeScreen.of(context).syncBloc,
          builder: (context, state) {
            IconData? icon;
            var iconColor = context.appColors.labelSecondary;
            VoidCallback? onPressed;
            if (networkStatus.isOnline) {
              icon = switch (state) {
                SyncInProgress() => Icons.cloud_sync,
                SyncSuccess() => Icons.cloud_done,
                SyncFailure() => Icons.cloud_off_rounded,
                _ => null,
              };
              if (state is SyncFailure) {
                iconColor = context.appColors.red;
                onPressed = () => _showSyncDialog(context);
              }
            } else {
              icon = Icons.airplanemode_on;
            }
            return _AnimatedIconButton(icon, iconColor, onPressed);
          },
        );
      },
    );
  }

  _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.appColors.backSecondary,
          title: Text(
            context.l10n.forceSyncTitle,
            style: context.appTextStyles.title.copyWith(
              color: context.appColors.labelPrimary,
              height: 1.2,
            ),
          ),
          content: Text(
            context.l10n.forceSyncText,
            style: context.appTextStyles.body.copyWith(
              color: context.appColors.labelPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: Text(
                context.l10n.forceSyncCancel,
                style: context.appTextStyles.body.copyWith(
                  color: context.appColors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                HomeScreen.of(context).blocDispatcher.syncTasks();
                context.pop();
              },
              child: Text(
                context.l10n.forceSyncRun,
                style: context.appTextStyles.body.copyWith(
                  color: context.appColors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedIconButton extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  const _AnimatedIconButton(
    this.icon,
    this.iconColor,
    this.onPressed,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: IconButton(
        key: UniqueKey(),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }
}

class _DoneTasksCounter extends StatelessWidget {
  const _DoneTasksCounter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      bloc: HomeScreen.of(context).tasksCubit,
      builder: (context, state) {
        return Text(
          context.l10n.tasksDone(state.doneTaskCount),
          style: context.appTextStyles.body.copyWith(
            color: context.appColors.labelTertiary,
          ),
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
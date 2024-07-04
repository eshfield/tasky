import 'package:app/data/services/network_status.dart';
import 'package:app/domain/bloc/sync_bloc.dart';
import 'package:app/domain/bloc/tasks_cubit.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/home_screen/widgets/tasks_visibility_button.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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
              _Title(),
              SizedBox(width: 16),
              _SyncIcon(),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              _DoneTasksCounter(),
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
    return Expanded(
      child: Text(
        context.l10n.homeTitle,
        style: context.appTextStyles.titleLarge.copyWith(
          color: context.appColors.labelPrimary,
        ),
      ),
    );
  }
}

class _SyncIcon extends StatelessWidget {
  const _SyncIcon();

  @override
  Widget build(BuildContext context) {
    final networkStatus = GetIt.I<NetworkStatus>();
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ListenableBuilder(
        listenable: networkStatus,
        builder: (context, child) {
          if (networkStatus.isOnline) {
            return BlocBuilder<SyncBloc, SyncState>(
              bloc: GetIt.I<SyncBloc>(),
              builder: (context, state) {
                final icon = switch (state) {
                  SyncInProgress() => Icons.cloud_sync,
                  SyncSuccess() => Icons.cloud_done,
                  SyncFailure() => Icons.cloud_off_rounded,
                  _ => null,
                };
                return _AnimatedIcon(icon);
              },
            );
          } else {
            return const _AnimatedIcon(Icons.cloud_off_rounded);
          }
        },
      ),
    );
  }
}

class _AnimatedIcon extends StatelessWidget {
  final IconData? icon;

  const _AnimatedIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Icon(
        key: UniqueKey(),
        icon,
        color: context.appColors.labelSecondary,
      ),
    );
  }
}

class _DoneTasksCounter extends StatelessWidget {
  const _DoneTasksCounter();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TasksCubit, TasksState>(
        bloc: GetIt.I<TasksCubit>(),
        builder: (context, state) {
          return Text(
            context.l10n.tasksDone(state.doneTaskCount),
            style: context.appTextStyles.body.copyWith(
              color: context.appColors.labelTertiary,
            ),
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }
}

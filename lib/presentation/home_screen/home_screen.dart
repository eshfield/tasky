import 'package:app/data/tasks.dart';
import 'package:app/domain/models/task.dart';
import 'package:app/l10n/l10n_extension.dart';
import 'package:app/presentation/add_task_screen/add_task_screen.dart';
import 'package:app/presentation/home_screen/widgets/header.dart';
import 'package:app/presentation/home_screen/widgets/task_list.dart';
import 'package:app/presentation/home_screen/widgets/top_bar.dart';
import 'package:app/presentation/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

const appTopBarHeight = 60.0;
const appTopBarAnimationDuration = Duration(milliseconds: 350);
const curve = Curves.easeInOutCubicEmphasized;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static HomeScreenState of(BuildContext context) =>
      _HomeScreenInheritedModel.of(
        context,
        listen: false,
      ).state;

  static List<Task> tasksToDisplayOf(BuildContext context) =>
      _HomeScreenInheritedModel.of(
        context,
        aspect: _Aspects.tasksToDisplay,
      ).tasksToDisplay;

  static bool showAppBarOf(BuildContext context) =>
      _HomeScreenInheritedModel.of(
        context,
        aspect: _Aspects.showAppBar,
      ).showAppBar;

  static bool showOnlyDoneTasksOf(BuildContext context) =>
      _HomeScreenInheritedModel.of(
        context,
        aspect: _Aspects.showOnlyDoneTasks,
      ).showOnlyDoneTasks;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  late List<Task> tasks;
  var showAppBar = false;
  var showOnlyDoneTasks = false;

  List<Task> get tasksToDisplay =>
      showOnlyDoneTasks ? tasks.where((task) => task.isDone).toList() : tasks;

  @override
  void initState() {
    super.initState();
    tasks = mockTasks;
    scrollController.addListener(handleScroll);
  }

  void handleScroll() {
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

  void addTask(Task taskToAdd) {
    setState(() {
      tasks = [taskToAdd, ...tasks];
    });
  }

  void removeTask(int taskIdToRemove) {
    setState(() {
      tasks = tasks.where((task) => task.id != taskIdToRemove).toList();
    });
  }

  void toggleTaskAsDone(int taskIdToMark) {
    setState(() {
      tasks = tasks.map((task) {
        if (task.id != taskIdToMark) return task;
        return task.copyWith(isDone: !task.isDone);
      }).toList();
    });
  }

  void toggleShowOnlyDoneTasks() {
    setState(() {
      showOnlyDoneTasks = !showOnlyDoneTasks;
    });
    scrollController.animateTo(0,
        duration: appTopBarAnimationDuration, curve: curve);
  }

  Future<void> createTask() async {
    final route = MaterialPageRoute<Task>(
      builder: (context) => const AddTaskScreen(),
    );
    final newTask = await Navigator.of(context).push<Task>(route);
    if (newTask != null) {
      addTask(newTask);
    }
  }

  int countDoneTasks() =>
      tasks.fold(0, (acc, task) => acc + (task.isDone ? 1 : 0));

  @override
  Widget build(BuildContext context) {
    return _HomeScreenInheritedModel(
      state: this,
      child: Scaffold(
        backgroundColor: context.appColors.backPrimary,
        body: const SafeArea(
          child: Stack(
            children: [
              _Content(),
              _TopBar(),
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

enum _Aspects {
  tasksToDisplay,
  showAppBar,
  showOnlyDoneTasks,
}

class _HomeScreenInheritedModel extends InheritedModel<_Aspects> {
  final HomeScreenState state;
  final List<Task> tasksToDisplay;
  final bool showAppBar;
  final bool showOnlyDoneTasks;

  _HomeScreenInheritedModel({
    required this.state,
    required super.child,
  })  : tasksToDisplay = state.tasksToDisplay,
        showAppBar = state.showAppBar,
        showOnlyDoneTasks = state.showOnlyDoneTasks;

  static _HomeScreenInheritedModel of(
    BuildContext context, {
    bool listen = true,
    _Aspects? aspect,
  }) =>
      maybeOf(context, listen: listen, aspect: aspect) ??
      (throw Exception(
          '$_HomeScreenInheritedModel was not found in the context'));

  static _HomeScreenInheritedModel? maybeOf(
    BuildContext context, {
    required bool listen,
    _Aspects? aspect,
  }) =>
      listen
          ? InheritedModel.inheritFrom(context, aspect: aspect)
          : context.getInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant _HomeScreenInheritedModel oldWidget) =>
      true;

  @override
  bool updateShouldNotifyDependent(
    covariant _HomeScreenInheritedModel oldWidget,
    Set<_Aspects> dependencies,
  ) =>
      (dependencies.contains(_Aspects.tasksToDisplay) &&
          tasksToDisplay != oldWidget.tasksToDisplay) ||
      (dependencies.contains(_Aspects.showAppBar) &&
          showAppBar != oldWidget.showAppBar) ||
      (dependencies.contains(_Aspects.showOnlyDoneTasks) &&
          showOnlyDoneTasks != oldWidget.showOnlyDoneTasks);
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final tasksToDisplay = HomeScreen.tasksToDisplayOf(context);
    return CustomScrollView(
      controller: HomeScreen.of(context).scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Header(
            doneTaskCount: HomeScreen.of(context).countDoneTasks(),
            shouldShowOnlyDoneTasks: HomeScreen.showOnlyDoneTasksOf(context),
            toggleShowOnlyDoneTasks:
                HomeScreen.of(context).toggleShowOnlyDoneTasks,
          ),
        ),
        tasksToDisplay.isEmpty
            ? const SliverFillRemaining(
                hasScrollBody: false,
                child: _Empty(),
              )
            : const TaskList(),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final showAppBar = HomeScreen.showAppBarOf(context);
    return AnimatedPositioned(
      top: showAppBar ? 0 : -appTopBarHeight,
      left: 0,
      right: 0,
      curve: curve,
      duration: appTopBarAnimationDuration,
      child: AnimatedOpacity(
        opacity: showAppBar ? 1 : 0,
        curve: curve,
        duration: appTopBarAnimationDuration,
        child: TopBar(
          title: context.l10n.appTitle,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: HomeScreen.of(context).toggleShowOnlyDoneTasks,
              icon: Icon(
                HomeScreen.showOnlyDoneTasksOf(context)
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: context.appColors.blue,
              ),
            ),
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
    return Center(
      child: Text(
        HomeScreen.showOnlyDoneTasksOf(context)
            ? context.l10n.noDoneTasks
            : context.l10n.noTasks,
        style: context.appTextStyles.subhead.copyWith(
          color: context.appColors.labelSecondary,
        ),
        textAlign: TextAlign.center,
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
        onPressed: HomeScreen.of(context).createTask,
        tooltip: context.l10n.addTaskTooltip,
        child: Icon(
          Icons.add,
          color: context.appColors.white,
        ),
      ),
    );
  }
}

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
const appTopBarScrollExtent = 60;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  late List<Task> _tasks;
  var _showAppBar = false;
  var _showOnlyDoneTasks = false;

  List<Task> get _tasksToDisplay => _showOnlyDoneTasks
      ? _tasks.where((task) => task.isDone).toList()
      : _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = tasks;
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    if (offset > appTopBarScrollExtent && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    }
    if (offset < appTopBarScrollExtent && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  void _addTask(Task taskToAdd) {
    setState(() {
      _tasks = [taskToAdd, ..._tasks];
    });
  }

  void _removeTask(int taskIdToRemove) {
    setState(() {
      _tasks = _tasks.where((task) => task.id != taskIdToRemove).toList();
    });
  }

  void _toggleTaskIsDone(int taskIdToMark) {
    setState(() {
      _tasks = _tasks.map((task) {
        if (task.id != taskIdToMark) return task;
        return task.copyWith(isDone: !task.isDone);
      }).toList();
    });
  }

  void _toggleShowOnlyDoneTasks() {
    setState(() {
      _showOnlyDoneTasks = !_showOnlyDoneTasks;
    });
    _scrollController.jumpTo(0);
  }

  Future<void> _createTask() async {
    final route = MaterialPageRoute<Task>(
      builder: (context) => const AddTaskScreen(),
    );
    final newTask = await Navigator.of(context).push<Task>(route);
    if (newTask != null) {
      _addTask(newTask);
    }
  }

  int _countDoneTasks() =>
      _tasks.fold(0, (acc, task) => acc + (task.isDone ? 1 : 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            _content(),
            _topBar(context),
          ],
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  Widget _content() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Header(
            doneTaskCount: _countDoneTasks(),
            shouldShowOnlyDoneTasks: _showOnlyDoneTasks,
            toggleShowOnlyDoneTasks: _toggleShowOnlyDoneTasks,
          ),
        ),
        _tasksToDisplay.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: _empty(),
              )
            : TaskList(
                _tasksToDisplay,
                removeTask: _removeTask,
                markTaskAsDone: _toggleTaskIsDone,
                createTask: _createTask,
              ),
      ],
    );
  }

  Widget _empty() {
    return Center(
      child: Text(
        _showOnlyDoneTasks ? context.l10n.noDoneTasks : context.l10n.noTasks,
        style: context.appTextStyles.subhead.copyWith(
          color: context.appColors.labelSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return AnimatedPositioned(
      top: _showAppBar ? 0 : -appTopBarHeight,
      left: 0,
      right: 0,
      curve: Curves.easeInOutCubicEmphasized,
      duration: appTopBarAnimationDuration,
      child: AnimatedOpacity(
        opacity: _showAppBar ? 1 : 0,
        curve: Curves.easeInOutCubicEmphasized,
        duration: appTopBarAnimationDuration,
        child: TopBar(
          title: context.l10n.appTitle,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: _toggleShowOnlyDoneTasks,
              icon: Icon(
                _showOnlyDoneTasks ? Icons.visibility_off : Icons.visibility,
                color: context.appColors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton(
        backgroundColor: context.appColors.blue,
        onPressed: _createTask,
        tooltip: context.l10n.addTaskTooltip,
        child: Icon(
          Icons.add,
          color: context.appColors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

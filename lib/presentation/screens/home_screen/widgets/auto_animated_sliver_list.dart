import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AutoAnimatedSliverList<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) idMapper;
  final Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) itemBuilder;
  final Duration initDuration;
  final Duration insertDuration;
  final Duration removeDuration;

  const AutoAnimatedSliverList({
    super.key,
    required this.items,
    required this.idMapper,
    required this.itemBuilder,
    this.initDuration = const Duration(milliseconds: 500),
    this.insertDuration = const Duration(milliseconds: 250),
    this.removeDuration = const Duration(milliseconds: 250),
  });

  @override
  State<AutoAnimatedSliverList<T>> createState() =>
      _AutoAnimatedSliverListState<T>();
}

class _AutoAnimatedSliverListState<T> extends State<AutoAnimatedSliverList<T>> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
  var _isFirstRun = true;
  var _isVisible = true;
  late VoidCallback _functionToRunLater;
  late AutoAnimatedSliverList<T> _oldWidget;

  @override
  void initState() {
    super.initState();
    _functionToRunLater = () {};
    // run initial list animation after SliverAnimatedList creation
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _listKey.currentState!.insertAllItems(
          0,
          widget.items.length,
          duration: widget.initDuration,
        );
        _isFirstRun = false;
      },
    );
  }

  void _updateList() {
    // adaptation of https://pub.dev/packages/automatic_animated_list
    final oldIds = _oldWidget.items.map(widget.idMapper).toList();
    final newIds = widget.items.map(widget.idMapper).toList();
    final diff = calculateListDiff(oldIds, newIds, detectMoves: false);
    final updates = diff.getUpdatesWithData();
    for (final update in updates) {
      if (update is DataInsert<String>) {
        _listKey.currentState!.insertItem(
          update.position,
          duration: widget.insertDuration,
        );
      } else if (update is DataRemove<String>) {
        _listKey.currentState!.removeItem(
          update.position,
          (context, animation) =>
              _oldWidget.itemBuilder(context, update.position, animation),
          duration: widget.removeDuration,
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant AutoAnimatedSliverList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldWidget = oldWidget;
    if (_isVisible) {
      _updateList();
    } else {
      // animation runs only if widget is visible, so it worth to wait for
      // (e.g. wait for closing task add/edit screen)
      _functionToRunLater = _updateList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverVisibilityDetector(
      key: const Key('AutoAnimatedSliverList'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _isVisible = false;
        } else {
          if (_isVisible) return;
          _functionToRunLater();
          // rerun build to use actual itemBuilder
          setState(() {
            _isVisible = true;
          });
        }
      },
      sliver: SliverAnimatedList(
        key: _listKey,
        initialItemCount: _isFirstRun ? 0 : widget.items.length,
        // if widget is not visible we use previous itemBuilder
        // since it contains items count before update;
        // otherwise off-by-one error occurs: new itemBuilder has updated
        // items count but we didn't change indexes with _updateList() yet
        itemBuilder: _isVisible ? widget.itemBuilder : _oldWidget.itemBuilder,
      ),
    );
  }
}

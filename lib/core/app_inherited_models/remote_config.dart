import 'dart:async';

import 'package:app/core/constants.dart';
import 'package:app/core/extensions/hex_color.dart';
import 'package:app/core/theme/theme.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfig extends StatefulWidget {
  final FirebaseRemoteConfig remoteConfig;
  final Widget child;

  const RemoteConfig({
    super.key,
    required this.remoteConfig,
    required this.child,
  });

  static Color importanceColorOf(BuildContext context) =>
      _RemoteConfigInheritedModel.of(
        context,
        aspect: _Aspect.importanceColor,
      ).importanceColor;

  @override
  State<RemoteConfig> createState() => RemoteConfigState();
}

class RemoteConfigState extends State<RemoteConfig> {
  late StreamSubscription<RemoteConfigUpdate> _remoteConfigSubscription;
  late Color importanceColor;

  @override
  void initState() {
    super.initState();

    importanceColor = AppTheme.lightAppColors.red;
    final importanceColorHex =
        widget.remoteConfig.getString(AppConstants.rcImportanceColorKey);
    if (importanceColorHex.isNotEmpty) {
      importanceColor = ColorHex.fromHex(importanceColorHex);
    }

    _remoteConfigSubscription =
        widget.remoteConfig.onConfigUpdated.listen(_handleRemoteConfigUpdates);
  }

  void _handleRemoteConfigUpdates(RemoteConfigUpdate event) async {
    await widget.remoteConfig.activate();
    final hexColor =
        widget.remoteConfig.getString(AppConstants.rcImportanceColorKey);
    if (hexColor.isEmpty) return;
    setState(() {
      importanceColor = ColorHex.fromHex(hexColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _RemoteConfigInheritedModel(
      state: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _remoteConfigSubscription.cancel();
    super.dispose();
  }
}

enum _Aspect {
  importanceColor,
}

class _RemoteConfigInheritedModel extends InheritedModel<_Aspect> {
  final RemoteConfigState state;
  final Color importanceColor;

  _RemoteConfigInheritedModel({
    required this.state,
    required super.child,
  }) : importanceColor = state.importanceColor;

  static _RemoteConfigInheritedModel of(
    BuildContext context, {
    bool listen = true,
    _Aspect? aspect,
  }) =>
      maybeOf(context, listen: listen, aspect: aspect) ??
      (throw Exception(
          '$_RemoteConfigInheritedModel was not found in the context'));

  static _RemoteConfigInheritedModel? maybeOf(
    BuildContext context, {
    required bool listen,
    _Aspect? aspect,
  }) =>
      listen
          ? InheritedModel.inheritFrom(context, aspect: aspect)
          : context.getInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    covariant _RemoteConfigInheritedModel oldWidget,
    Set<_Aspect> dependencies,
  ) =>
      (dependencies.contains(_Aspect.importanceColor) &&
          importanceColor != oldWidget.importanceColor);
}

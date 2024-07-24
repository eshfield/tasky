import 'package:flutter/material.dart';

enum Env {
  dev,
  prod,
}

enum AnalyticsEvent {
  addTask,
  removeTask,
  toggleTaskAsDone,
  screenNavigation,
}

enum AnalyticsParameter {
  taskId,
  taskText,
  updatedValue,
  navigationDestination,
}

abstract class AppConstant {
  static const envArg = 'TASKY_ENV';
  // can't use Env.dev.name for default value because it is not a const
  // as it requires by String.fromEnvironment() method
  static const envArgDefaultValue = 'dev';
  static const tokenArg = 'TASKY_API_TOKEN';

  static const unknownDeviceId = 'UNKNOWN_DEVICE';

  static const appTopBarHeight = 60.0;
  static const appTopBarAnimationDuration = Duration(milliseconds: 350);
  static const appTorBarCurve = Curves.easeInOutCubicEmphasized;

  static const rcImportanceColorKey = 'importanceColor';
}

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

const envArg = 'TASKY_ENV';
// can't use Env.dev.name for default value because it is not a const
const envArgDefaultValue = 'dev';
const tokenArg = 'TASKY_API_TOKEN';

const unknownDeviceId = 'UNKNOWN_DEVICE';

const appTopBarHeight = 60.0;
const appTopBarAnimationDuration = Duration(milliseconds: 350);
const appTorBarCurve = Curves.easeInOutCubicEmphasized;

const rcImportanceColorKey = 'importanceColor';

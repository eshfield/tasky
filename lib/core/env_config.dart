import 'package:app/core/constants.dart';

class EnvConfig {
  static const env = String.fromEnvironment(
    AppConstants.envArg,
    defaultValue: AppConstants.envArgDefaultValue,
  );

  static bool get isNotProd => env != Env.prod.name;

  static String get apiToken {
    const token = String.fromEnvironment(AppConstants.tokenArg);
    if (token.isEmpty) throw Exception('Empty API token');
    return token;
  }
}

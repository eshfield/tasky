import 'package:app/core/constants.dart';

class EnvConfig {
  static const env = String.fromEnvironment(
    AppConstant.envArg,
    defaultValue: AppConstant.envArgDefaultValue,
  );

  static bool get isNotProd => env != Env.prod.name;

  static String get apiToken {
    const token = String.fromEnvironment(AppConstant.tokenArg);
    if (token.isEmpty) throw Exception('Empty API token');
    return token;
  }
}

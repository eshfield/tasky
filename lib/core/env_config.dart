import 'package:app/core/constants.dart';

class EnvConfig {
  static const env = String.fromEnvironment(
    envArg,
    defaultValue: envArgDefaultValue,
  );

  static bool get isNotProd => env != Env.prod.name;

  static String get apiToken {
    const token = String.fromEnvironment(tokenArg);
    if (token.isEmpty) throw Exception('Empty API token');
    return token;
  }
}

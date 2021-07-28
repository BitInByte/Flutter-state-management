import 'package:get_it/get_it.dart';

import '../../constants/env_values.dart';

class ConstantDependencies {
  // Setup dependencies to be injected
  static void setupDependencies() {
    // Singleton means the same instance for all injection
    GetIt.instance.registerSingleton<Api>(Api());
  }
}

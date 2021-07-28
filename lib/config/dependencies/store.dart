import 'package:get_it/get_it.dart';

import '../../features/tasks/blocs/task_bloc.dart';

class StoreDependencies {
  // Setup dependencies to be injected
  static void setupDependencies() {
    // Singleton means the same instance for all injection
    GetIt.instance.registerSingleton<TaskBloc>(TaskBloc());
  }
}

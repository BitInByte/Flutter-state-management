import 'package:get_it/get_it.dart';

import '../../features/tasks/blocs/task_bloc.dart';

// Setup dependencies to be injected
void setupDependencies() {
  // Singleton means the same instance for all injection
  GetIt.instance.registerSingleton<TaskBloc>(TaskBloc());
}

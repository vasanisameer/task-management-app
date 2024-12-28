import 'package:riverpod/riverpod.dart';
import 'package:sameer_assigment/models/task.dart';
import 'package:sameer_assigment/services/database_helper.dart';

final taskProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel();
});

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final tasks = await DatabaseHelper.instance.fetchTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    fetchTasks();
  }
}

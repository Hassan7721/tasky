import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class TasksController extends ChangeNotifier {
  bool isLoading = false;

  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> highPriorityTasks = [];

  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;

  init() {
    _loadTasks();
  }

  void _loadTasks() {
    isLoading = true;

    final finalTask = PreferencesManager().getString(StorageKey.tasks);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      _loadDate();

      _calculatePercent();
    }

    isLoading = false;

    notifyListeners();
  }

  void _loadDate() {
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completeTasks = tasks.where((element) => element.isDone).toList();

    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();

    highPriorityTasks = highPriorityTasks.reversed.toList();
  }

  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);

    tasks[index].isDone = value ?? false;

    _loadDate();
    print('Completed: ${completeTasks.length}');
print('To Do: ${todoTasks.length}');
print('Total: ${tasks.length}');
    _calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));

    notifyListeners();
    print('TasksController notified listeners');
  }

  deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);
    _loadDate();
    
    _calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));

    notifyListeners();
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
  }
}

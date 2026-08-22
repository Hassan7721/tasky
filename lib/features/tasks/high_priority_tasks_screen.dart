import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/widgets/task_list_widgets.dart';

class HighPriorityTasksScreen extends StatefulWidget {
  const HighPriorityTasksScreen({super.key});

  @override
  State<HighPriorityTasksScreen> createState() =>
      _HighPriorityTasksScreenState();
}

class _HighPriorityTasksScreenState extends State<HighPriorityTasksScreen> {
  List<TaskModel> highPriorityTasks = [];
  bool isLoadig = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoadig = true;
    });

    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString('tasks');

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        highPriorityTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isHighPriority)
            .toList();

        highPriorityTasks = highPriorityTasks.reversed.toList();
      });
    }

    setState(() {
      isLoadig = false;
    });
  }

  _delteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;

    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        highPriorityTasks.removeWhere((task) => task.id == id);
      });
      // todo shared method
      final updatedTask = highPriorityTasks
          .map((element) => element.toJson())
          .toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoadig
            ? const Center(child: CircularProgressIndicator())
            : TaskListWidgets(
                tasks: highPriorityTasks,
                onTap: (value, index) async {
                  setState(() {
                    highPriorityTasks[index!].isDone = value ?? false;
                  });
                  final allDate = PreferencesManager().getString("tasks");
                  //  final pref = await SharedPreferences.getInstance();
                  // final allDate = pref.getString('tasks');

                  if (allDate != null) {
                    List<TaskModel> allDateList = (jsonDecode(allDate) as List)
                        .map((element) => TaskModel.fromJson(element))
                        .toList();

                    final int newIndex = allDateList.indexWhere(
                      (e) => e.id == highPriorityTasks[index!].id,
                    );

                    allDateList[newIndex] = highPriorityTasks[index!];
                    await PreferencesManager().setString(
                      "tasks",
                      jsonEncode(allDateList),
                    );
                    // pref.setString("tasks", jsonEncode(allDateList));

                    _loadTask();
                  }
                },
                emptyMessage: "No Task Found",
                onDelete: (int? id) {
                  _delteTask(id);
                }, onEdit: (){
                  _loadTask();
                },
              ),
      ),
    );
  }
}

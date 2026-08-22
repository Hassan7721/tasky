import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/core/components/task_list_widgets.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];
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

    final finalTask = PreferencesManager().getString('tasks');

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        todoTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => !element.isDone)
            .toList();
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
        todoTasks.removeWhere((task) => task.id == id);
      });
      // todo shared method
      final updatedTask = todoTasks
          .map((element) => element.toJson())
          .toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTask));
    }
  }


    
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            "To Do Tasks",
            style:Theme.of(context).textTheme.labelSmall,
            
             
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoadig
                ? const Center(child: CircularProgressIndicator())
                : TaskListWidgets(
                    tasks: todoTasks,
                    onTap: (value, index) async {
                      setState(() {
                        todoTasks[index!].isDone = value ?? false;
                      });

                      final allDate = PreferencesManager().getString('tasks');

                      if (allDate != null) {
                        List<TaskModel> allDateList =
                            (jsonDecode(allDate) as List)
                                .map((element) => TaskModel.fromJson(element))
                                .toList();

                        final int newIndex = allDateList.indexWhere(
                          (e) => e.id == todoTasks[index!].id,
                        );

                        allDateList[newIndex] = todoTasks[index!];

                         PreferencesManager().setString("tasks", jsonEncode(allDateList));

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
        ),
      ],
    );
  }
}

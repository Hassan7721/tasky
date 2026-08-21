import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/widgets/task_list_widgets.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {

  List<TaskModel> completTask = [];
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
    final finalTask = PreferencesManager().getString("tasks");
  

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
          

        completTask = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((elment)=>elment.isDone==true)  
            .toList();
       // tasks=tasks.where((elment)=>elment.isDone==false).toList();   
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
        completTask.removeWhere((task) => task.id == id);
      });
      // todo shared method
      final updatedTask = completTask
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
          
          padding: EdgeInsets.all(18),
          child: Text(
            "Completed Tasks",
           style:Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: isLoadig
                  ? Center(child: CircularProgressIndicator(value: 20))
                  : TaskListWidgets(
                      tasks: completTask,
                      onTap: (value, index) async {
                          setState(() {
                          completTask[index!].isDone = value ?? false;
                        });
                         final allDate = PreferencesManager().getString("tasks");
                       
                     
                        if (allDate != null) {
          
                          List<TaskModel> allDateList = (jsonDecode(allDate) as List)
                              .map((element) => TaskModel.fromJson(element))
                              .toList();
          
                          final int newIndex = allDateList.indexWhere(
                            (e) => e.id == completTask[index!].id,
                          );
                          allDateList[newIndex] = completTask[index!];
                          await PreferencesManager().setString("tasks",jsonEncode(allDateList));
                         
                          _loadTask();
                        }
                      },
                      emptyMessage: "No Task Found", 
                      onDelete: (int? id) {
                          _delteTask(id);
                        },
                         onEdit: () {
                           _loadTask();
                           
                           },
                    ),
            ),
        ),
      ],
    );
    
  }
}
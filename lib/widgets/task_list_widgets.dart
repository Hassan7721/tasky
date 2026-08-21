//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:tasky/core/theme/theme_controller.dart';
//import 'package:tasky/core/widgets/custom_check_boox.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widgets.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tasky/task_model.dart';

class TaskListWidgets extends StatelessWidget {
  const TaskListWidgets({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    required this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function( int?) onDelete;
  final Function onEdit;
  final String emptyMessage;
  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage ?? 'No Date',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
        : ListView.separated(
            physics:
                NeverScrollableScrollPhysics(), //بيمنع  انك تسكرول في ال ماي ناسك
            shrinkWrap: true,
            itemCount: tasks.length,
            padding: EdgeInsets.only(bottom: 50),
            itemBuilder: (BuildContext context, int index) {
              return TaskItemWidgets(
                model: tasks[index],
                onChanged: (bool? value) {
                  onTap(value, index);
                },
                onDelete: (int? id) {
                  onDelete(id);
                }, 
                onEdit: ()=>onEdit(),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8);
            },
          );
  }
}

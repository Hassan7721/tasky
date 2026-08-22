
import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/core/components/task_item_widgets.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tasky/task_model.dart';

class SliverTaskListWidgets extends StatelessWidget {
  const SliverTaskListWidgets({
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
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(color: Color(0xFFFFFCFC), fontSize: 20),
              ),
            ),
          )
        : SliverPadding(
            padding: EdgeInsetsGeometry.only(bottom: 60),
            sliver: SliverList.separated(
              // physics: NeverScrollableScrollPhysics(),//بيمنع  انك تسكرول في ال ماي ناسك
              itemCount: tasks.length,

              itemBuilder: (BuildContext context, int index) {
                return TaskItemWidgets(
                  model: tasks[index],
                  onChanged: (bool? value) {
                    onTap(value, index);
                    
                  }, onDelete: (int? id) { 
                    onDelete(id);
                   }, onEdit: ()=>onEdit(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          );
  }
}

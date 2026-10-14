import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/core/components/task_list_widgets.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            "Completed Tasks",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: controller.isLoading
                ? Center(child: CircularProgressIndicator(value: 20))
                : Consumer<TasksController>(
                    builder: (BuildContext context, value, Widget? child) {
                      return TaskListWidgets(
                        tasks: value.completeTasks,
                        onTap: (value, index) async {
                          controller.doneCompleteTask(value, index);
                        },
                        emptyMessage: "No Task Found",
                        onDelete: (int? id) {
                          controller.deleteTask(id);
                        },
                        onEdit: () {
                          controller.init();
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

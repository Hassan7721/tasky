import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/core/components/task_list_widgets.dart';

class HighPriorityTasksScreen extends StatelessWidget {
  const HighPriorityTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<TasksController>(
                builder: (BuildContext context, valueController, Widget? child) {
                  return TaskListWidgets(
                    tasks: valueController.highPriorityTasks,
                    onTap: (value, index) async {
                      controller.doneTask(value, valueController.highPriorityTasks[index!].id);
                    },
                    emptyMessage: "No Task Found",
                    onDelete: (int? id) {
                      controller.deleteTask(id);
                    },
                    onEdit: () {
                      controller.init;
                    },
                  );
                },
              ),
      ),
    );
  }
}

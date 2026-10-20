import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/components/task_list_widgets.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';

class TodoTasksScreen extends StatelessWidget {
  const TodoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
     return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'To Do Tasks',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: controller.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Consumer<TasksController>(
                        builder: (BuildContext context, valueController, Widget? child) {
                          return TaskListWidgets(
                            tasks: valueController.todoTasks,
                            onTap: (value, index) async {
                              controller.doneTask(value,valueController.todoTasks[index!].id);
                            },
                            emptyMessage: 'No Task Found',
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

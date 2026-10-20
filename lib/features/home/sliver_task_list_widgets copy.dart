import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/components/task_item_widgets.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:tasky/task_model.dart';

class SliverTaskListWidgets extends StatelessWidget {
  const SliverTaskListWidgets({
    super.key,

   
    
  });


  
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController controller, Widget? child) {
        final tasksList=controller.tasks;
        return controller.isLoading
            ? const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              )
            : controller.tasks.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "No Date",
                    style: TextStyle(color: Color(0xFFFFFCFC), fontSize: 24),
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsetsGeometry.only(bottom: 60),
                sliver: SliverList.separated(
                  // physics: NeverScrollableScrollPhysics(),//بيمنع  انك تسكرول في ال ماي ناسك
                  itemCount: tasksList.length,

                  itemBuilder: (BuildContext context, int index) {
                    return TaskItemWidgets(
                      model: tasksList[index],
                      onChanged: (bool? value) {
                        controller.doneTask(value,tasksList[index].id);
                       
                      },
                      onDelete: (int? id) {
                        controller.deleteTask(id);
                      },
                      onEdit: () => controller.init(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 8);
                  },
                ),
              );
      },
    );
  }
}

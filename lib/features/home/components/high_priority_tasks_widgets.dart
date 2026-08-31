import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/coustom_svg_picture.dart';
import 'package:tasky/core/widgets/custom_check_boox.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/features/tasks/high_priority_tasks_screen.dart';
//import 'package:tasky/task_model.dart';

class HighPriorityTasksWidgets extends StatelessWidget {
  const HighPriorityTasksWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
            final tasksList = controller.tasks;
            return Container(
              //padding: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "High Priority Tasks",
                            style: TextStyle(
                              color: Color(0xFF15B86C),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        //zedBox(height: 8),
                        //.take mean take(4) first 4 element
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              tasksList.reversed
                                      .where((e) => e.isHighPriority)
                                      .length >
                                  4
                              ? 4
                              : tasksList.reversed
                                    .where((e) => e.isHighPriority)
                                    .length,
                          itemBuilder: (BuildContext context, int index) {
                            final task = tasksList.reversed
                                .where((e) => e.isHighPriority)
                                .toList()[index];
                            return Row(
                              children: [
                                CustomCheckBoox(
                                  value: task.isDone,
                                  onChanged: (bool? value) {
                                    final index = tasksList.indexWhere(
                                      (e) => e.id == task.id,
                                    );
                                    controller.doneTask(value,index);
                                   
                                  },
                                ),

                                Flexible(
                                  child: Text(
                                    task.taskName,
                                    style: task.isDone
                                        ? Theme.of(context).textTheme.titleLarge
                                        : Theme.of(
                                            context,
                                          ).textTheme.titleMedium,

                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return HighPriorityTasksScreen();
                          },
                        ),
                      );
                        controller.loadTask();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 56,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,

                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeController.isDark()
                                ? Color(0xFF6E6E6E)
                                : Color(0xFFD1DAD6),
                          ),
                        ),

                        child: Container(
                          padding: EdgeInsets.all(14.0),
                          child: CoustomSvgPicture(
                            path: "assets/images/final_aroow.svg",
                          ),
                        ),

                        // CoustomSvgPicture(
                        //   path: "assets/images/aroow_up.svg",
                        //   height: 24,
                        //   width: 24,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}

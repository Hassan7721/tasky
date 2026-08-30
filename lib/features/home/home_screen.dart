import 'dart:io';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/widgets/coustom_svg_picture.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/features/home/components/achieved_tasks_widgets.dart';
import 'package:tasky/features/home/components/high_priority_tasks_widgets.dart';
import 'package:tasky/features/home/sliver_task_list_widgets%20copy.dart';
//import 'package:tasky/widgets/task_list_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController()..init(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, value, Widget? child) {
          final controller = context.read<HomeController>();

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: value.userImagePath == null
                                  ? const AssetImage(
                                      "assets/images/person.png",
                                    )
                                  : FileImage(
                                      File(value.userImagePath!),
                                    ),
                            ),

                            const SizedBox(width: 8),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening, ${value.username}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 16),
                                ),

                                Text(
                                  "One task at a time. One step closer.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Yuhuu, Your work Is",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),

                        Row(
                          children: [
                            Text(
                              "almost done!",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),

                            CoustomSvgPicture.withoutColor(
                              path: "assets/images/waving_hand.svg",
                              width: 32,
                              height: 32,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        AchievedTasksWideget(
                          totalDoneTasks: value.totalDoneTasks,
                          perecnt: value.perecnt,
                          totalTask: value.totalTask,
                        ),

                        const SizedBox(height: 8),

                        HighPriorityTasksWidgets(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          refresh: () {
                            controller.loadTask();
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            bottom: 16,
                          ),
                          child: Text(
                            "My Tasks",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  value.isLoadig
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SliverTaskListWidgets(
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) async {
                            controller.doneTask(value, index);
                          },
                          emptyMessage: "No Date",
                          onDelete: (int? id) {
                            controller.delteTask(id);
                          },
                          onEdit: () {
                            controller.loadTask();
                          },
                        ),
                ],
              ),
            ),

            floatingActionButton: SizedBox(
              height: 44,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTask();
                      },
                    ),
                  );

                  print(result);

                  if (result != null && result) {
                    controller.loadTask();
                  }
                },
                label: const Text("Add New Task"),
                icon: const Icon(Icons.add),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
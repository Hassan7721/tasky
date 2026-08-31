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
      child: Scaffold(
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
                        Selector<HomeController, String?>(
                          selector: (context, HomeController controller) =>
                              controller.userImagePath,
                          builder:
                              (
                                BuildContext context,
                                userImagePath,
                                Widget? child,
                              ) {
                                return CircleAvatar(
                                  backgroundImage: userImagePath == null
                                      ? const AssetImage(
                                          "assets/images/person.png",
                                        )
                                      : FileImage(File(userImagePath)),
                                );
                              },
                        ),

                        const SizedBox(width: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<HomeController, String?>(
                              selector: (context, HomeController controller) =>
                                  controller.username,
                              builder:
                                  (
                                    BuildContext context,
                                    String? username,
                                    Widget? child,
                                  ) {
                                    return Text(
                                      "Good Evening, $username",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 16),
                                    );
                                  },
                            ),

                            Text(
                              "One task at a time. One step closer.",
                              style: Theme.of(context).textTheme.titleSmall,
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

                    AchievedTasksWideget(),

                    const SizedBox(height: 8),

                    HighPriorityTasksWidgets(),

                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Text(
                        "My Tasks",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),

              SliverTaskListWidgets(),
            ],
          ),
        ),

        floatingActionButton: SizedBox(
          height: 44,
          child: Builder(
            builder: (BuildContext controllerContext) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTask();
                      },
                    ),
                  );

                  if (result != null && result) {
                    controllerContext.read<HomeController>().loadTask();
                    //controller.loadTask();
                  }
                },
                label: const Text("Add New Task"),
                icon: const Icon(Icons.add),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

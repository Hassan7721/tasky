import 'dart:convert';
import 'dart:io';
//import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/widgets/coustom_svg_picture.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';
//import 'package:tasky/task_model.dart';
import 'package:tasky/widgets/achieved_tasks_widgets.dart';
import 'package:tasky/widgets/high_priority_tasks_widgets.dart';
import 'package:tasky/widgets/sliver_task_list_widgets%20copy.dart';
//import 'package:tasky/widgets/task_list_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? userImagePath;

  List<TaskModel> tasks = [];
  bool isLoadig = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double perecnt = 0;

  @override
  void initState() {
    super.initState();
    _loadusername();
    _loadTask();
  }

  void _loadusername() async {
    setState(() {
      username = PreferencesManager().getString("username");
      userImagePath = PreferencesManager().getString("user_image");
    });
  }

  void _loadTask() async {
    setState(() {
      isLoadig = true;
    });

    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskAfterDecode
            .map((elment) => TaskModel.fromJson(elment))
            .toList();
        _calculatePerecnt();
      });
    }
    setState(() {
      isLoadig = false;
    });
  }

  @override
  _calculatePerecnt() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    perecnt = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePerecnt();
    });

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  _delteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePerecnt();
    });
    // todo shared method
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xFF181818),
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
                        backgroundImage: userImagePath == null
                            ? AssetImage("assets/images/person.png")
                            : FileImage(File(userImagePath!)),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username ",
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium!.copyWith(fontSize: 16),
                          ),
                          Text(
                            "One task at a time.One step closer.",

                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      CoustomSvgPicture.withoutColor(
                        path: "assets/images/waving_hand.svg",
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  //Achieved Tasks
                  SizedBox(height: 16),
                  AchievedTasksWideget(
                    totalDoneTasks: totalDoneTasks,
                    perecnt: perecnt,
                    totalTask: totalTask,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidgets(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTask();
                    },
                  ),
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
            isLoadig
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(value: 20)),
                  )
                : SliverTaskListWidgets(
                    tasks: tasks,
                    onTap: (bool? value, int? index) async {
                      _doneTask(value, index);
                    },
                    emptyMessage: "No Date",
                    onDelete: (int? id) {
                      _delteTask(id);
                    },
                    onEdit: () {
                      _loadTask();
                    },
                  ),
          ],

          /* child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
        
              isLoadig
                  ? Center(child: CircularProgressIndicator(value: 20))
                  : TaskListWidgets(
                      tasks: tasks,
                      onTap: (bool? value, int? index) async {
                        _doneTask(value, index);
                      },
                      emptyMessage: "No Date",
                    ),
        
              //   if (task.isNotEmpty)
            ],
          ),*/
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
            if (result != null && result) //=>&& result mean result=true
            {
              _loadTask();
            }
          },

          label: Text("Add New Task"),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/coustm_text_form_field.dart';
import 'package:tasky/core/widgets/custom_check_boox.dart';
import 'package:tasky/models/task_model.dart';

import '../enums/task_item_actions_enum.dart';

class TaskItemWidgets extends StatelessWidget {
  const TaskItemWidgets({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });
  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBoox(
            value: model.isDone,
            onChanged: (bool? value) => onChanged(value),
          ),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (model
                    .taskDescription
                    .isNotEmpty) // لو محطتش وصف هيخلي التاسك واخد المسافه
                  Text(
                    model.taskDescription,
                    style: TextStyle(
                      color: Color(0xFFC6C6C6),
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.delete:
                  await _showAlertDialog(context);

                case TaskItemActionsEnum.edit:
                final result=  await _showButtonSheet(context, model);
                if(result==true){
                      onEdit();
                }
                
              }
            },
            itemBuilder: (context) => [
              ...TaskItemActionsEnum.values.map((e) {
                return PopupMenuItem<TaskItemActionsEnum>(
                  value: e,
                  child: Text(e.name),
                );
              }),

              // PopupMenuItem(value: TaskItemActionsEnum.delete, child: Text("Delete")),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _showAlertDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you wnat to delete this task"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },

              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<bool?>  _showButtonSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDesceiptionController = TextEditingController(
      text: model.taskDescription,
    );
    GlobalKey<FormState> key = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      context: context,
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          CoustmTextFormField(
                            controller: taskNameController,
                            hintText: 'Finish UI design for login screen',
                            title: "Task Name",
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please Enter Your Task Name";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 20),
                          CoustmTextFormField(
                            controller: taskDesceiptionController,
                            maxLines: 5,
                            hintText:
                                'Finish onboarding UI and hand off to devs by Thursday.',
                            title: "Task Description",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority ",
                          style:Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          value: isHighPriority,
                          onChanged: (bool value) {
                            setState(() {
                              isHighPriority = value;
                            });
                          },
                          // activeTrackColor: Color(0xFF15B86C),
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      onPressed: () async {
                        //   print(_key.currentState);
                        if (key.currentState?.validate() ?? false) {
                           final taskjson = PreferencesManager().getString(StorageKey.tasks);

                             List<dynamic> listTasks = [];
                            if (taskjson != null) {
                              listTasks = jsonDecode(taskjson);
                            }
                            TaskModel newModel = TaskModel(
                              id: model.id + 1,
                              taskName: taskNameController.text,
                              taskDescription: taskDesceiptionController.text,
                              isHighPriority: isHighPriority,
                              isDone: model.isDone,
                            );

                            final item=listTasks.firstWhere(
                              (e)=> e['id']==model.id,
                              
                            );

                          final int index=listTasks.indexOf(item);

                          listTasks[index]=newModel;

                          //   final task = <String, dynamic>{
                          //     "taskName": taskNameController.text,
                          //     "taskDescription": taskDesceiptionController.text,
                          //     "isHighPriority": isHighPriority,
                          //   };

                          //   listTasks.add(model.toJson());

                            final taskEncode = jsonEncode(listTasks);
                           await PreferencesManager().setString(StorageKey.tasks, taskEncode);

                       
                             Navigator.of(context).pop(true);
                        }
                      },
                      label: Text("Edit Task"),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

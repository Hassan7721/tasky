import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/widgets/coustm_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDesceiptionController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isHighPriority = true;

  // TODOO: DISPOSE THIS CONTROLLERS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFF181818),
        centerTitle: false,
        title: Text("New Task"),
        // titleTextStyle: TextStyle(color: Color(0xFFFFFCFC), fontSize: 20),

        // iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

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
                        title:"Task Description" ,    
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
                      style: Theme.of(context).textTheme.titleMedium,
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
                    if (_key.currentState?.validate() ?? false) {
                      
                     
                     final taskjson = PreferencesManager().getString(StorageKey.tasks);
                      
                      List<dynamic> listTasks = [];
                      if (taskjson != null) {
                        listTasks = jsonDecode(taskjson);
                      }
                      TaskModel model = TaskModel(
                        id: listTasks.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDesceiptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      //   print(model.toJson());

                      final task = <String, dynamic>{
                        "taskName": taskNameController.text,
                        "taskDescription": taskDesceiptionController.text,
                        "isHighPriority": isHighPriority,
                      };

                      listTasks.add(model.toJson());

                      final taskEncode = jsonEncode(listTasks);
                     await PreferencesManager().setString(StorageKey.tasks, taskEncode);
                     

                      // Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    }
                  },
                  label: Text("Add Task"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class HomeController  with ChangeNotifier{
  List<TaskModel>taskList=[];
    String? username = "Default";
  String? userImagePath;

  List<TaskModel> tasks = [];
  bool isLoadig = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double perecnt = 0;
  HomeController(){
    init();
  }


  init(){

    loadUserDate();
    loadTask();
  }

  

    void loadUserDate() async {
   
      username = PreferencesManager().getString(StorageKey.username);
      userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }

  void loadTask() async {
    
      isLoadig = true;
  
 

    final finalTask = PreferencesManager().getString(StorageKey.tasks);

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

     
        tasks = taskAfterDecode
            .map((elment) => TaskModel.fromJson(elment))
            .toList();
        calculatePerecnt();
        notifyListeners();
    
    }
    
      isLoadig = false;
    notifyListeners();
  }
    @override
  calculatePerecnt() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    perecnt = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  doneTask(bool? value, int? index) async {
  
      tasks[index!].isDone = value ?? false;
      calculatePerecnt();
    notifyListeners();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
  }

  deleteTask(int? id) async {
    if (id == null) return;
    
      tasks.removeWhere((task) => task.id == id);
      calculatePerecnt();
    notifyListeners();
    // todo shared method
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
  
}
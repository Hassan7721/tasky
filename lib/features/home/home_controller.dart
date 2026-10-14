
import 'package:flutter/material.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';

class HomeController  with ChangeNotifier{
  List<TaskModel>taskList=[];
    String? username = "Default";
  String? userImagePath;

  bool isLoadig = false;

  HomeController(){
    init();
  }


  init(){

    loadUserDate();
  
  }

  

    void loadUserDate() async {
   
      username = PreferencesManager().getString(StorageKey.username);
      userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }






  
}
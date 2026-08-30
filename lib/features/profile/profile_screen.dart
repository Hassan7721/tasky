import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/components/constants/storage_key.dart';

import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/coustom_svg_picture.dart';
import 'package:tasky/features/profile/user_detailes_screen.dart';
import 'package:tasky/features/welcome/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String motivationQuote;
  String? userImagePath;
  bool isLoadig = true;
  

  @override
  void initState() {
    super.initState();
    _loadDate();
  }

  void _loadDate() async {
    setState(() {
      username = PreferencesManager().getString(StorageKey.username) ?? '';
      motivationQuote =
          PreferencesManager().getString(StorageKey.motivationQuote) ??
          "One task at a time. One step closer.";
      userImagePath = PreferencesManager().getString(StorageKey.userImage);

      isLoadig = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoadig
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),

                  child: Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: userImagePath == null
                                ? AssetImage("assets/images/person.png")
                                : FileImage(File(userImagePath!)),
                            radius: 60,
                            backgroundColor: Colors.transparent,
                          ),

                          GestureDetector(
                            onTap: () async {
                              showImageSourceDialog(context, (XFile file) {
                                //save image
                                _saveImage(file);
                                setState(() {
                                  userImagePath = file.path;
                                });
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                // color: Color(0xFFFFFCFC),
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),

                      Text(
                        username,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Profile Info",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SizedBox(height: 19),
                ListTile(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return UserDetailesScreen(
                            userName: username,
                            motivationQuote: motivationQuote,
                          );
                        },
                      ),
                    );
                    if (result != null && result) {
                      _loadDate();
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text("User Details"),
                  leading: CoustomSvgPicture(path: "assets/images/profile.svg"),

                  trailing: CoustomSvgPicture(path: "assets/images/aroow.svg"),
                ),

                // SizedBox(height: 13),
                Divider(thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,

                  title: Text("Dark Mode"),
                  leading: CoustomSvgPicture(path: "assets/images/Dark.svg"),

                  trailing: ValueListenableBuilder(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (bool value) async {
                          ThemeController.toggleTheme();
                        },
                      );
                    },
                    // child:
                  ),
                ),
                Divider(thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    PreferencesManager().remove(StorageKey.username);
                    PreferencesManager().remove(StorageKey.motivationQuote);
                    PreferencesManager().remove(StorageKey.tasks);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return WelcomeScreen();
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },

                  title: Text("Log Out"),
                  leading: CoustomSvgPicture(path: "assets/images/logOut.svg"),

                  trailing: CoustomSvgPicture(path: "assets/images/aroow.svg"),
                ),
              ],
            ),
          );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();

    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    PreferencesManager().setString(StorageKey.userImage, newFile.path);
  }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(
          "Choose  Image source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),

            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text("Camear"),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),

            child: Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text("Gallery"),
              ],
            ),
          ),
        ],
      );
    },
  );
}

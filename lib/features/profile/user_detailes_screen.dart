import 'package:flutter/material.dart';
import 'package:tasky/core/components/constants/storage_key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/widgets/coustm_text_form_field.dart';

class UserDetailesScreen extends StatefulWidget {
   const UserDetailesScreen({
    super.key,
    required this.userName,
    required this.motivationQuote,
  });

  final String userName;
 final String? motivationQuote;

  @override
  State<UserDetailesScreen> createState() => _UserDetailesScreenState();
}

class _UserDetailesScreenState extends State<UserDetailesScreen> {
  late final TextEditingController userNameController ;

 late final TextEditingController motivationQuoteController ;

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    userNameController=TextEditingController(text: widget.userName);
    motivationQuoteController=TextEditingController(text:widget.motivationQuote);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              CoustmTextFormField(
                controller: userNameController,
                hintText: "Hassan Ashraf",
                title: "User Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter User Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CoustmTextFormField(
                controller: motivationQuoteController,
                hintText: "One task at a time. One step closer.",
                title: "Motivation Quote",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Motivation Quote";
                  }
                  return null;
                },
              ),
              Spacer(),

              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    await PreferencesManager().setString(StorageKey.username,userNameController.value.text);
                    await PreferencesManager().setString(StorageKey.motivationQuote,motivationQuoteController.value.text);
                 
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

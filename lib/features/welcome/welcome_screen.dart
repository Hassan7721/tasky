import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/widgets/coustm_text_form_field.dart';
import 'package:tasky/core/widgets/coustom_svg_picture.dart';
//import 'package:tasky/home_screen.dart';
import 'package:tasky/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CoustomSvgPicture.withoutColor(
                        path: "assets/images/logo.svg",
                        width: 42,
                        height: 42,
                      ),

                      SizedBox(width: 16),
                      Text(
                        'Tasky',

                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 118),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky ",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      CoustomSvgPicture.withoutColor(
                        path: "assets/images/waving_hand.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your productivity journey starts here.",
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CoustomSvgPicture.withoutColor(
                    path: "assets/images/welcome.svg",
                    height: 200,
                    width: 215,
                  ),

                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        CoustmTextFormField(
                          controller: controller,
                          hintText: "e.g Saad Ashraf",
                          title: "Full Name",
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please Enter Your Full Name";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //  backgroundColor: Color(0xFF15B86C),
                      ///  foregroundColor: Color(0xFFFFFCFC),
                      fixedSize: Size(370, 40),
                    ),
                    onPressed: () async {
                      if (_key.currentState?.validate() ?? false) {
                        await PreferencesManager().setString(
                          "username",
                          controller.value.text,
                        );

                        //String? username = pref.getString("username");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MainScreen();
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please Enter Your Full Name"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Let’s Get Started",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        // color: Color(0xFFFFFCFC),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

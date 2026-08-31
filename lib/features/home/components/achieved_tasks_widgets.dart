import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/home_controller.dart';

class AchievedTasksWideget extends StatelessWidget {
  const AchievedTasksWideget({
    super.key,
    // required this.totalDoneTasks,
    // required this.perecnt,
    // required this.totalTask,
  });

  // final int totalDoneTasks;
  // final double perecnt;
  // final int totalTask;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController controller, Widget? child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Color(0xFF282828),
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*  Text(
                          "$totalDoneTasks   Out of $totalTask Done",
                          style:Theme.of(context).textTheme.titleMedium,
                        ),*/
                  Text(
                    "Achieved Tasks",

                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${ controller.totalDoneTasks}   Out of ${ controller.totalTask} Done",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Stack(
                //Stack بتحط الويدجتش فوق بعضها
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -pi / 2,
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: CircularProgressIndicator(
                        value:controller.perecnt,
                        backgroundColor: Color(0xFF6D6D6D),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF15B86C),
                        ),
                        strokeWidth: 4,
                      ),
                    ),
                  ),

                  Text(
                    "${((controller.perecnt * 100).toInt())}%",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class AchievedTasksWideget extends StatelessWidget {
  const AchievedTasksWideget({super.key, required this.totalDoneTasks, required this.perecnt, required this.totalTask});

final int totalDoneTasks;
final double perecnt;
final int totalTask;
  @override
  Widget build(BuildContext context) {
    return  Container(
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
                        "$totalDoneTasks   Out of $totalTask Done",
                        style:Theme.of(context).textTheme.titleSmall,

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
                            value: perecnt,
                            backgroundColor: Color(0xFF6D6D6D),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF15B86C),
                            ),
                            strokeWidth: 4,
                          ),
                        ),
                      ),

                      Text(
                        "${((perecnt * 100).toInt())}%",
                        style:Theme.of(context).textTheme.titleMedium,
                       
                      ),
                    ],
                  ),
                ],
              ),
            );
  }
}
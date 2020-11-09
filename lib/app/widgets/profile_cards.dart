import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({this.displayText});
  final String displayText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      child: FractionallySizedBox(
        widthFactor: 0.92,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              decoration: BoxDecoration(
                color: FitnessAppTheme.nearlyWhite,
                boxShadow: [
                  BoxShadow(
                    color: FitnessAppTheme.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              height: 60,
              child: Row(
                children: [
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                    flex: 3,
                    child: Text(
                      displayText,
                      style: FitnessAppTheme.commonTextStyle
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: -5,
              child: Image(
                height: 100,
                width: 100,
                image: AssetImage('assets/app_images/breakfast.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

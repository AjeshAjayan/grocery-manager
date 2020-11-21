import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';

class LinearProgressBar extends StatelessWidget {
  static final ValueNotifier<bool> show = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: show,
      builder: (context, value, child) {
        return Container(
          child: SafeArea(
            child: value ? LinearProgressIndicator(
              backgroundColor: FitnessAppTheme.nearlyDarkBlue,
              valueColor: const AlwaysStoppedAnimation(FitnessAppTheme.nearlyWhite),
            ) : Container(),
          ),
        );
      },
    );
  }
}

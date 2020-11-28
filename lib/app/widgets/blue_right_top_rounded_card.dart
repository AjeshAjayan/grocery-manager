

import 'package:flutter/material.dart';

import '../home_theme.dart';

class BlueRightTopRoundedCard extends StatefulWidget {
  BlueRightTopRoundedCard({this.child});
  final Widget child;
  @override
  _BlueRightTopRoundedCardState createState() => _BlueRightTopRoundedCardState();
}

class _BlueRightTopRoundedCardState extends State<BlueRightTopRoundedCard> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: HomeTheme.boxShadow,
          gradient: LinearGradient(
              colors: [HomeTheme.nearlyDarkBlue, HomeTheme.nearlyWhite],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0.7, 1]),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(150),
          ),
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
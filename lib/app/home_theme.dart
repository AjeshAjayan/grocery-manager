import 'package:flutter/material.dart';

class HomeTheme {
  HomeTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color shadedDarkBlue = Color(0xFF3948bd);
  static const Color primarySplashColor = Color(0x502633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const Color nearlyLiteDarkBlue = Color(0x702633C5);

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static final TextStyle commonWhiteTextStyle = TextStyle(
    color: HomeTheme.white,
    fontSize: 20,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const TextStyle commonTextStyle = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    letterSpacing: 0.2,
    color: HomeTheme.nearlyBlack, // was lightText
  );

  static final List<BoxShadow> boxShadow = [
    BoxShadow(
      color: HomeTheme.grey.withOpacity(0.4),
      offset: const Offset(1.1, 1.1),
      blurRadius: 10.0,
    ),
  ];

  static Widget buildBlueOutlinedInput(
      {String labelText,
      TextEditingController controller,
      String hintText,
      TextInputType textInputType}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(
          color: HomeTheme.nearlyDarkBlue,
        ),
        keyboardType: textInputType,
        controller: controller,
        cursorColor: HomeTheme.nearlyDarkBlue,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: HomeTheme.nearlyLiteDarkBlue),
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(
            color: HomeTheme.nearlyDarkBlue,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HomeTheme.nearlyDarkBlue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HomeTheme.nearlyDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}

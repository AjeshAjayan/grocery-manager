import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';
import 'package:grocery_manager/app/widgets/blue_right_top_rounded_card.dart';

class ShopDetails extends StatefulWidget {
  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlueRightTopRoundedCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verified :',
                  style: HomeTheme.commonWhiteTextStyle,
                ),
                SizedBox(width: 10),
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: 20),
                RaisedButton(
                  onPressed: () {
                    // TODO
                  },
                  color: HomeTheme.shadedDarkBlue,
                  child: Container(
                    child: Text('Revert', style: HomeTheme.commonWhiteTextStyle),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(color: HomeTheme.nearlyDarkBlue),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';

class ShopCard extends StatefulWidget {
  ShopCard({this.connectionState, this.shop});

  final ConnectionState connectionState;
  final dynamic shop;

  @override
  _ShopCardState createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/app_images/sticky_notes.png',
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: widget.connectionState == ConnectionState.done
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.shop['shop_name'] ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        widget.shop['addressLineOne'] ?? '',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      Text(
                        widget.shop['addressLineTwo'] ?? '',
                        style: TextStyle(color: Colors.teal),
                      ),
                      Text(
                        "pin: ${widget.shop['postalCode'] ?? 'nil'}",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Image.asset('assets/app_images/shop_loader.gif'),
                ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_manager/app/home_theme.dart';
import 'package:grocery_manager/app/widgets/blue_right_top_rounded_card.dart';
import 'package:grocery_manager/app/widgets/linear_progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetails extends StatefulWidget {
  ShopDetails({this.shopDetails, this.docId});

  final dynamic shopDetails;
  final String docId;

  final CollectionReference shopUsers =
  FirebaseFirestore.instance.collection('shop_users');

  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {

  bool isVerified;

  @override
  void initState() {

    this.isVerified = widget.shopDetails['is_verified'] ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          this.shopVerified(),
          SizedBox(
            height: 10,
          ),
          this.shopDetails(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget shopVerified() {
    return BlueRightTopRoundedCard(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verified :',
                style: HomeTheme.commonWhiteTextStyle,
              ),
              SizedBox(width: 10),
              this.isVerified
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.close, color: Colors.red),
            ],
          ),
          SizedBox(height: 20),
          this.isVerified
              ? RaisedButton(
                  onPressed: () => _setVerifiedAs(false),
                  color: HomeTheme.shadedDarkBlue,
                  child: Container(
                    child:
                        Text('Revert', style: HomeTheme.commonWhiteTextStyle),
                  ),
                )
              : RaisedButton(
                  onPressed: () => _setVerifiedAs(true), // set shop as verified
                  color: HomeTheme.shadedDarkBlue,
                  child: Container(
                    child: Text('Set as verified',
                        style: HomeTheme.commonWhiteTextStyle),
                  ),
                )
        ],
      ),
    );
  }

  Widget shopDetails() {
    return BlueRightTopRoundedCard(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.shopDetails['shop_name'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Text(
            widget.shopDetails['addressLineOne'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Text(
            widget.shopDetails['addressLineTwo'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Text(
            widget.shopDetails['name'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Text(
            widget.shopDetails['postalCode'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Text(
            'landmark: ' + widget.shopDetails['landmark'],
            style: HomeTheme.commonWhiteTextStyle,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: HomeTheme.white),
              SizedBox(width: 10),
              Text(
                widget.shopDetails['phone_number'],
                style: HomeTheme.commonWhiteTextStyle,
              ),
            ],
          ),
          SizedBox(height: 10),
          RaisedButton(
            onPressed: () => _launchMap(
              lat: widget.shopDetails['latitude'],
              long: widget.shopDetails['longitude'],
            ), // launch location of shop on map
            color: HomeTheme.shadedDarkBlue,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open on map',
                      style: HomeTheme.commonWhiteTextStyle,
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.location_on, color: HomeTheme.white)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _launchMap({double lat, double long}) async {
    LinearProgressBar.show.value = true;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      LinearProgressBar.show.value = false;
      throw 'Could not launch $url';
    }
    LinearProgressBar.show.value = false;
  }

  _setVerifiedAs(bool status) async {
    LinearProgressBar.show.value = true;

    await widget.shopUsers.doc(widget.docId).update({
      'is_verified': status
    });
    setState(() {
      this.isVerified = status;
    });
    LinearProgressBar.show.value = false;
  }
}

import 'package:flutter/material.dart';

import 'default_button.dart';
import 'main1.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(46),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.16),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/images/logo.png",
            height: 25,
            alignment: Alignment.topCenter,
          ),
          SizedBox(width: 5),
          Spacer(),
          DefaultButton(
            text: "Get Started",
            press: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => CanvasPainting()));
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'constant.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "WhiteBoard 2.0",
            style: Theme.of(context).textTheme.headline1.copyWith(
                  color: kTextcolor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            "Nothing more Nothing less.",
            style: TextStyle(
              fontSize: 27,
              color: kTextcolor.withOpacity(1.0),
            ),
          ),
//          FlatButton.icon(
//              color: Colors.white,
//              onPressed: () {
//                Navigator.push(
//                    context,
//                    new MaterialPageRoute(
//                        builder: (context) => CanvasPainting()));
//              },
//              icon: Icon(Icons.album),
//              label: Text('Get Started')),
        ],
      ),
    );
  }
}

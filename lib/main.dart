import 'dart:async';
import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:teachersapp/animation_page.dart';
import 'package:teachersapp/notes_main.dart';

void main() {
  runApp(MaterialApp(home: CanvasPainting()));
}

// void main() => runApp(CanvasPainting());

class CanvasPainting extends StatefulWidget {
  @override
  _CanvasPaintingState createState() => _CanvasPaintingState();
}

class _CanvasPaintingState extends State<CanvasPainting> {
  List<TouchPoints> points = List();
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap
      .round; //(Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickStroke() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return ClipOval(
          child: AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  strokeWidth = 3.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 24,
                ),
                onPressed: () {
                  strokeWidth = 10.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 40,
                ),
                onPressed: () {
                  strokeWidth = 30.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 60,
                ),
                onPressed: () {
                  strokeWidth = 50.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _opacity() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return ClipOval(
          child: AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 24,
                ),
                onPressed: () {
                  opacity = 0.1;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 40,
                ),
                onPressed: () {
                  opacity = 0.5;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 60,
                ),
                onPressed: () {
                  opacity = 1.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> fabOption() {
    return <Widget>[
      new FloatingActionButton(
        heroTag: "Animation",
        child: Icon(Icons.business),
        tooltip: 'Animation',
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => FlipBookApp()));
        },
      ),
      new FloatingActionButton(
        heroTag: "Quick Notes",
        child: Icon(Icons.assignment),
        tooltip: 'Quick Notes',
        onPressed: () {
          Navigator.push(
              context, new MaterialPageRoute(builder: (context) => NotesApp()));
        },
      ),
      new FloatingActionButton(
        heroTag: "paint_stroke",
        child: Icon(Icons.brush),
        tooltip: 'Stroke',
        onPressed: () {
          //min: 0, max: 50
          setState(() {
            _pickStroke();
          });
        },
      ),
      new FloatingActionButton(
        heroTag: "paint_opacity",
        child: Icon(Icons.opacity),
        tooltip: 'Opacity',
        onPressed: () {
          //min:0, max:1
          setState(() {
            _opacity();
          });
        },
      ),
      new FloatingActionButton(
          heroTag: "Clear Screen",
          child: Icon(Icons.delete),
          tooltip: "Clear Screen",
          onPressed: () {
            setState(() {
              points.clear();
            });
          }),
      new FloatingActionButton(
          heroTag: "Undo",
          child: Icon(Icons.undo),
          tooltip: "Undo",
          onPressed: () {
            setState(() {
              if (points.isNotEmpty) {
                for (int i = 0; i < 13; i++) points.removeLast();
              }
            });
          }),
      FloatingActionButton(
        heroTag: "eraser",
        child: Icon(MdiIcons.eraser),
        tooltip: 'Eraser',
        onPressed: () {
          setState(() {
            selectedColor = Colors.white70;
            strokeWidth = 50.0;
          });
        },
      ),
      new FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_red",
        child: colorMenuItem(Colors.red),
        onPressed: () {
          setState(() {
            selectedColor = Colors.red;
          });
        },
      ),
      new FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_black",
        child: colorMenuItem(Colors.black),
        onPressed: () {
          setState(() {
            selectedColor = Colors.black;
          });
        },
      ),
      new FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "color_blue",
          child: colorMenuItem(Colors.blue),
          onPressed: () {
            setState(() {
              selectedColor = Colors.blue;
            });
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          backgroundColor: Colors.white70,
          body: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject();
                points.add(TouchPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeType
                      ..isAntiAlias = true
                      ..color = selectedColor.withOpacity(opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanStart: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject();
                points.add(TouchPoints(
                    points: renderBox.globalToLocal(details.globalPosition),
                    paint: Paint()
                      ..strokeCap = strokeType
                      ..isAntiAlias = true
                      ..color = selectedColor.withOpacity(opacity)
                      ..strokeWidth = strokeWidth));
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null);
              });
            },
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size.infinite,
                  painter: MyPainter(pointsList: points),
                ),
              ],
            ),
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            fabButtons: fabOption(),
            colorStartAnimation: Colors.blue,
            colorEndAnimation: Colors.cyanAccent,
            animatedIconData: AnimatedIcons.menu_close,
          ),
        ),
      ),
    );
  }

  Widget colorMenuItem(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 45,
          width: 45,
          color: color,
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({this.pointsList});
  List<TouchPoints> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [pointsList[i].points], pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

class TouchPoints {
  Paint paint;
  Offset points;
  TouchPoints({this.points, this.paint});
}

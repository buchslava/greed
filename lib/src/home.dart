import 'dart:math';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  // https://stackoverflow.com/questions/53278792/sliding-animation-to-bottom-in-flutter
  // Animation<Offset> animation;
  // AnimationController animController;

  AnimationController controller;
  Animation<Offset> offset;

  double buttonWidth = 50.0;
  List<PlayerButton> board = [];
  double objectTop;
  double objectLeft;
  double subjectTop;
  double subjectLeft;

  @override
  void initState() {
    super.initState();

    /*animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    animation = Tween(begin: Offset(0.0, 0.0), end: Offset(80.0, 80.0)).animate(
      CurvedAnimation(
        parent: animController,
        curve: Curves.easeIn,
      ),
    );*/

    WidgetsBinding.instance.addPostFrameCallback((_){
         // Schedule code execution once after the frame has rendered
         print(MediaQuery.of(context).size.toString());
      });

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));

    offset = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 1.0))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    board = [];
    double left = 0.0;
    for (int i = 0; i < 5; i++, left += buttonWidth) {
      double top = 0.0;
      for (int j = 0; j < 6; j++, top += buttonWidth) {
        board.add(PlayerButton((i + j).toString(), top, left));
      }
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text('go'),
              onPressed: () {
                switch (controller.status) {
                  case AnimationStatus.completed:
                    controller.reverse();
                    break;
                  case AnimationStatus.dismissed:
                    controller.forward();
                    break;
                  default:
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SlideTransition(
              position: offset,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  
    /*return Scaffold(
      appBar: AppBar(
        title: Text("Animation!"),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: board
                .map((boardItem) => buildButtonAnimation(boardItem))
                .toList(),
          ),
        ),
      ),
    );*/
  }

  Widget buildButtonAnimation(PlayerButton source) {
    AnimationController animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    Animation<Offset> animation = Tween(
            begin: Offset(objectTop, objectLeft),
            end: Offset(subjectTop, subjectLeft))
        .animate(
      CurvedAnimation(
        parent: animController,
        curve: Curves.easeIn,
      ),
    );

    return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: animation,
          child: OutlineButton(
              child: Text(source.text,
                  style: TextStyle(
                      color:
                          source.top == objectTop && source.left == objectLeft
                              ? Colors.red
                              : Colors.black)),
              onPressed: () {
                setState(() {
                  if (subjectTop != null && subjectLeft != null) {
                    animController.forward();
                    return;
                  }
                  if (objectTop == null && objectLeft == null) {
                    objectTop = source.top;
                    objectLeft = source.left;
                  } else {
                    subjectTop = source.top;
                    subjectLeft = source.left;
                  }
                });
              }),
        ));

    /*return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: source.top + animation.value,
          left: source.left + animation.value,
          width: buttonWidth,
          height: buttonWidth,
        );
      },
      child: OutlineButton(
          child: Text(source.text,
              style: TextStyle(
                  color: source.top == objectTop && source.left == objectLeft
                      ? Colors.red
                      : Colors.black)),
          onPressed: () {
            setState(() {
              /*if (animController.status == AnimationStatus.completed) {
                animController.reverse();
              } else if (animController.status == AnimationStatus.dismissed) {
                animController.forward();
              }*/
              if (subjectTop != null && subjectLeft != null) {
                animController.forward();
                return;
              }
              if (objectTop == null && objectLeft == null) {
                objectTop = source.top;
                objectLeft = source.left;
              } else {
                subjectTop = source.top;
                subjectLeft = source.left;
              }
            });
          }),
    );*/
  }
}

class PlayerButton {
  String text;
  double top;
  double left;
  Widget w;

  PlayerButton(this.text, this.top, this.left) {}
}

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;
  double buttonWidth = 50.0;
  List<Widget> board = [];

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    animation = Tween(begin: 0.0, end: 80.0).animate(
      CurvedAnimation(
        parent: animController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    board = [];
    double left = 0.0;
    for (int i = 0; i < 5; i++, left += buttonWidth) {
      double top = 0.0;
      for (int j = 0; j < 6; j++, top += buttonWidth) {
        board.add(buildButtonAnimation((i + j).toString(), top, left));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation!"),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: board,
          ),
        ),
      ),
    );
  }

  Widget buildButtonAnimation(String text, double top, double left) {
    return AnimatedBuilder(
      // get new coords here
      animation: Tween(begin: 0.0, end: 80.0).animate(
        CurvedAnimation(
          parent: animController,
          curve: Curves.easeIn,
        ),
      ),
      builder: (context, child) {
        return Positioned(
          child: child,
          top: top + animation.value,
          left: left + animation.value,
          width: buttonWidth,
          height: buttonWidth,
        );
      },
      child: OutlineButton(
          child: Text(text),
          onPressed: () {
            setState(() {
              if (animController.status == AnimationStatus.completed) {
                animController.reverse();
              } else if (animController.status == AnimationStatus.dismissed) {
                animController.forward();
              }
            });
          }),
    );
  }
}

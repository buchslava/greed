import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Widget a1, a2;

  List<String> numbers = [
    '1',
    '11',
    '4',
    '5',
    '1',
    '9',
    '8',
    '17',
    '23',
    '20',
    '12',
  ];

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    catAnimation = Tween(begin: 0.0, end: 80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    a1 = buildCatAnimation("1", 0, 0);
    a2 = buildCatAnimation("22", 100, 100);
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation!"),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              a1,
              a2,
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
    /*return Scaffold(
        appBar: AppBar(
          title: Text("?"),
        ),
        body: Container(
          color: Colors.white30,
          child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: numbers.map((String n) {
                GlobalKey gk = GlobalKey();
                return OutlineButton(
                    key: gk,
                    child: Text(n),
                    onPressed: () {
                      _getPositions(gk);
                    });
              }).toList()),
        ));*/
  }

  /*_getPositions(GlobalKey gk) {
    final RenderBox renderBox = gk.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    print("${position.dx} - ${position.dy}");
  }*/

  Widget buildCatAnimation(String text, double top, double left) {
    print("build");
    return AnimatedBuilder(
      // get new coords here
      animation: Tween(begin: 0.0, end: 80.0).animate(
        CurvedAnimation(
          parent: catController,
          curve: Curves.easeIn,
        ),
      ),
      builder: (context, child) {
        return Positioned(
          child: child,
          top: top + catAnimation.value,
          left: left + catAnimation.value,
        );
      },
      child: Text(text),
    );
  }

  void onTap() {
    setState(() {
      if (catController.status == AnimationStatus.completed) {
        catController.reverse();
      } else if (catController.status == AnimationStatus.dismissed) {
        catController.forward();
      }
    });
  }
}

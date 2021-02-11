import 'package:flutter/material.dart';

class MainBounceTabar extends StatefulWidget {
  @override
  _MainBounceTabarState createState() => _MainBounceTabarState();
}

class _MainBounceTabarState extends State<MainBounceTabar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.black,
          ),
          Container(color: Colors.green),
          Container(
            color: Colors.purple,
          ),
        ],
      ),
      bottomNavigationBar: BounceTabBar(
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.blue,
        items: [
          Icon(Icons.ac_unit),
          Icon(Icons.umbrella),
          Icon(Icons.wallet_giftcard),
          Icon(Icons.data_usage),
        ],
      ),
    );
  }
}

class BounceTabBar extends StatefulWidget {
  const BounceTabBar({
    Key key,
    @required this.backgroundColor,
    @required this.items,
    @required this.onTabChanged,
    this.initialIndex = 0,
    this.movement = 100,
  }) : super(key: key);

  final Color backgroundColor;
  final List<Widget> items;
  final ValueChanged<int> onTabChanged;
  final int initialIndex;
  final double movement;

  @override
  _BounceTabBarState createState() => _BounceTabBarState();
}

class _BounceTabBarState extends State<BounceTabBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animTabBarIn;
  Animation _animTabBarOut;
  Animation _animCircleItem;
  Animation _animElevationIn;
  Animation _animElevationOut;

  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animTabBarIn = CurveTween(
      curve: Interval(0.1, 0.6, curve: Curves.decelerate),
    ).animate(_controller);

    _animTabBarOut =
        CurveTween(curve: Interval(0.6, 1.0, curve: Curves.bounceOut))
            .animate(_controller);

    _animCircleItem = CurveTween(
        curve: Interval(
      0.0,
      0.5,
    )).animate(_controller);

    _animElevationIn =
        CurveTween(curve: Interval(0.3, 0.5, curve: Curves.decelerate))
            .animate(_controller);
    _animElevationOut =
        CurveTween(curve: Interval(0.55, 1.0, curve: Curves.bounceOut))
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double currenWidth = width;
    double currenElevation = 0.0;
    _controller.forward(from: 0.0);
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          currenWidth = width -
              (widget.movement * _animTabBarIn.value) +
              (widget.movement * _animTabBarOut.value);

          currenElevation = -widget.movement * _animElevationIn.value +
              (widget.movement - kBottomNavigationBarHeight / 4) *
                  _animElevationOut.value;

          return Center(
            child: Container(
              width: currenWidth,
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.items.length, (index) {
                    final child = widget.items[index];
                    final innerWidget = CircleAvatar(
                        radius: 30.0,
                        backgroundColor: widget.backgroundColor,
                        child: child);
                    if (index == _currentIndex) {
                      return Expanded(
                        child: GestureDetector(
                            onTap: () {
                              widget.onTabChanged(index);
                              _controller.forward(from: 0.0);
                            },
                            child: CustomPaint(
                              foregroundPainter:
                                  _CircleItemPainter(_animCircleItem.value),
                              child: Transform.translate(
                                offset: Offset(0.0, currenElevation),
                                child: innerWidget,
                              ),
                            )),
                      );
                    } else {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.onTabChanged(index);
                              _currentIndex = index;
                            });
                            _controller.forward(from: 0.0);
                          },
                          child: innerWidget,
                        ),
                      );
                    }
                  })),
            ),
          );
        },
      ),
    );
  }
}

class _CircleItemPainter extends CustomPainter {
  final double progress;

  _CircleItemPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = 20.0 * progress;
    final strokeWidth = 10.0;

    final currentStrokeWidth = strokeWidth * (1 - progress);

    if (progress < 1.0) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = currentStrokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            SnakeButton(
              child: Text(
                'MainBounceTabar',
                style: TextStyle(color: Colors.white),
              ),
              snakeColor: Colors.red,
              borderColor: Colors.yellow,
              boderWidth: 4,
              onTap: () {
                Navigator.pushNamed(context, 'MainBounceTabar');
              },
              duration: Duration(milliseconds: 2000),
            ),
            SizedBox(
              height: 20,
            ),
            SnakeButton(
              child: Text(
                'ViewDocument',
                style: TextStyle(color: Colors.white),
              ),
              snakeColor: Colors.blue,
              borderColor: Colors.transparent,
              boderWidth: 4,
              onTap: () {
                Navigator.pushNamed(context, 'ViewDocument');
                // print('ViewDocument 111');
              },
            ),
            SizedBox(
              height: 20,
            ),
            SnakeButton(
              child: Text(
                'Menu lateral',
                style: TextStyle(color: Colors.white),
              ),
              snakeColor: Colors.blue,
              borderColor: Colors.transparent,
              boderWidth: 4,
              onTap: () {
                Navigator.pushNamed(context, 'MainSideMenu');
                // print('object 111');
              },
            ),
            SizedBox(
              height: 20,
            ),
            SnakeButton(
              child: Text(
                'Share Button Animation',
                style: TextStyle(color: Colors.white),
              ),
              snakeColor: Colors.blue,
              borderColor: Colors.transparent,
              boderWidth: 4,
              onTap: () {
                Navigator.pushNamed(context, 'MainSocialShareButtons');
              },
            ),
            SizedBox(
              height: 20,
            ),
            SnakeButton(
              child: Text(
                'Hola Diego',
                style: TextStyle(color: Colors.white),
              ),
              snakeColor: Colors.blue,
              borderColor: Colors.transparent,
              boderWidth: 4,
              onTap: () {
                print('object 111');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SnakeButton extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color snakeColor;
  final Color borderColor;
  final double boderWidth;
  final VoidCallback onTap;

  const SnakeButton(
      {Key key,
      this.duration,
      this.child,
      this.snakeColor,
      this.borderColor,
      this.boderWidth = 6.0,
      this.onTap})
      : super(key: key);
  @override
  _SnakeButtonState createState() => _SnakeButtonState();
}

class _SnakeButtonState extends State<SnakeButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration ?? const Duration(milliseconds: 1500));
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: _SnackPainter(
            borderColor: widget.borderColor,
            boderWidth: widget.boderWidth,
            snakeColor: widget.snakeColor,
            animation: _controller),
        child: Container(
          // color: Colors.blue,
          alignment: Alignment.center,
          child:
              Padding(padding: const EdgeInsets.all(15.0), child: widget.child),
        ),
      ),
    );
  }
}

class _SnackPainter extends CustomPainter {
  final Animation animation;
  final Color snakeColor;
  final Color borderColor;
  final double boderWidth;

  _SnackPainter(
      {@required this.animation,
      this.snakeColor = Colors.purple,
      this.borderColor = Colors.white,
      this.boderWidth = 4.0})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
              colors: [
            snakeColor,
            borderColor,
          ],
              stops: [
            0.7,
            1.0
          ],
              startAngle: 0.0,
              endAngle: vector.radians(80),
              transform:
                  GradientRotation(vector.radians(360) * animation.value))
          .createShader(rect);

    final path = Path.combine(PathOperation.xor, Path()..addRect(rect),
        Path()..addRect(rect.deflate(6.0)));
    // path.addRect(rect);

    canvas.drawRect(
        rect.deflate(boderWidth / 2),
        Paint()
          ..color = Colors.white
          ..strokeWidth = boderWidth
          ..style = PaintingStyle.stroke);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

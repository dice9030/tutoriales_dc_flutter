import 'package:flutter/material.dart';

final backgroundColors = [
  Color(0xFF8122BF),
  Color(0xFFCA32F5),
  Color(0xFFF2B634),
];

class MainSocialShareButtons extends StatelessWidget {
  const MainSocialShareButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: DecoratedBox(
        decoration:
            BoxDecoration(gradient: LinearGradient(colors: backgroundColors)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SocialSharButton(
              children: [
                IconButton(icon: Icon(Icons.face), onPressed: () {}),
                IconButton(
                  icon: Icon(Icons.mail),
                  onPressed: () {},
                ),
                IconButton(icon: Icon(Icons.face), onPressed: () {}),
                IconButton(icon: Icon(Icons.face), onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialSharButton extends StatefulWidget {
  // const SocialSharButton({Key key, this.height = 100}) : super(key: key);

  const SocialSharButton(
      {Key key,
      this.height = 100,
      this.buttonStyle,
      this.buttonColor = Colors.black,
      this.childrenColor = Colors.white,
      this.buttonLabel = 'DIEGO',
      this.children})
      : super(key: key);

  final double height;
  final List<Widget> children;
  final TextStyle buttonStyle;
  final Color buttonColor;
  final Color childrenColor;
  final String buttonLabel;

  @override
  _SocialSharButtonState createState() => _SocialSharButtonState();
}

class _SocialSharButtonState extends State<SocialSharButton> {
  final _buttonsKey = GlobalKey();
  double _buttonsWidth = 0.0;
  bool _expanded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _buttonsWidth = _buttonsKey.currentContext.size.width + 14;
        // print(_buttonsWidth);
      });
    });
    super.initState();
  }

  Widget _buildTopWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      height: widget.height / 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        key: _buttonsKey,
        children: widget.children,
      ),
    );
  }

  Widget _builBottomWidget() {
    final borderRadius = BorderRadius.circular(8);
    return Material(
      elevation: 5,
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: () {
          setState(() {
            _expanded = !_expanded;
          });
        },
        borderRadius: borderRadius,
        child: Container(
          width: _buttonsWidth,
          height: widget.height / 2,
          alignment: Alignment.center,
          child: Text(
            widget.buttonLabel,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movement = widget.height / 4;
    return TweenAnimationBuilder<double>(
        tween: !_expanded
            ? Tween(begin: 0.0, end: 1.0)
            : Tween(begin: 1.0, end: 0.0),
        duration: _buttonsWidth == 0
            ? const Duration(milliseconds: 1)
            : const Duration(milliseconds: 400),
        builder: (context, value, _) {
          return Container(
            height: widget.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(0.0, movement * value),
                  child: _buildTopWidget(),
                ),
                Transform.translate(
                  offset: Offset(0.0, -movement * value),
                  child: _builBottomWidget(),
                ),
                // _builBottomWidget()
              ],
            ),
          );
        });
  }
}

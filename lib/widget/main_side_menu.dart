import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MainSideMenu extends StatefulWidget {
  @override
  _MainSideMenuState createState() => _MainSideMenuState();
}

class _MainSideMenuState extends State<MainSideMenu> {
  final _data = List<String>.generate(8, (index) {
    if (index == 0) {
      return 'assets/side_menu/icon_close.png';
    } else {
      return 'assets/side_menu/icon_$index.png';
    }
  });

  int _selectedIndex = 1;

  Widget _getWidget() {
    Widget value;
    if (_selectedIndex.isOdd) {
      value = Container(
        color: Colors.red,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      value = Container(
        color: Colors.yellow,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    // return SideMenu.build(
    //     selectedColor: Color(0xFFCE5C7F),
    //     unselectedColor: Color(0xFF3A3B55),
    //     onItemSelected: (index) {
    //       if (index != 0) {
    //         setState(() {
    //           _selectedIndex = index;
    //         });
    //       }
    //     },
    //     menuWidth: 80,
    //     builder: (showMenu) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           leading: IconButton(
    //             icon: Icon(Icons.menu),
    //             onPressed: showMenu,
    //           ),
    //         ),
    //         body: _getWidget(),
    //       );
    //     },
    //     items: _data
    //         .map((e) => Padding(
    //             padding: const EdgeInsets.all(20.0), child: Image.asset(e)))
    //         .toList());

    return SideMenu(
        onItemSelected: (index) {
          if (index != 0) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedColor: Color(0xFFCE5C7F),
        unselectedColor: Color(0xFF3A3B55),
        menuWidth: 80,
        views: List.generate(
            _data.length,
            (index) => Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(child: Text(index.toString())),
                )),
        appBarBuilder: (showMenu) {
          return AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Mensaje',
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.grey,
              onPressed: showMenu,
            ),
          );
        },
        items: _data
            .map((e) => Padding(
                padding: const EdgeInsets.all(20.0), child: Image.asset(e)))
            .toList());
  }
}

typedef SideMenuBuilder = Widget Function(VoidCallback showMenu);
typedef SideMenuAppBarBuilder = AppBar Function(VoidCallback showMenu);

const _sideMenuWidth = 100.0;
const _sideMenuDuration = const Duration(milliseconds: 800);

class SideMenu extends StatefulWidget {
  const SideMenu.build({
    Key key,
    this.builder,
    this.items,
    this.onItemSelected,
    this.selectedColor,
    this.unselectedColor,
    this.menuWidth = _sideMenuWidth,
    this.duration = _sideMenuDuration,
  })  : this.views = null,
        this.appBarBuilder = null,
        super(key: key);

  const SideMenu({
    Key key,
    this.views,
    this.items,
    this.onItemSelected,
    this.selectedColor,
    this.unselectedColor,
    this.menuWidth = _sideMenuWidth,
    this.duration = _sideMenuDuration,
    this.appBarBuilder,
  })  : this.builder = null,
        super(key: key);

  final SideMenuBuilder builder;
  final SideMenuAppBarBuilder appBarBuilder;
  final List<Widget> items;
  final ValueChanged<int> onItemSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final double menuWidth;
  final Duration duration;
  final List<Widget> views;

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  List<Animation<double>> _animations;

  int _selectedIndex = 1;
  int _oldSelectedIndex = 1;
  bool wasZeroIndexPressed = false;

  @override
  void initState() {
    // TODO: implement initState

    _animationController =
        AnimationController(vsync: this, duration: widget.duration);

    final _itervalGap = 1 / widget.items.length;
    _animations = List.generate(
            widget.items.length,
            (index) => Tween(begin: 0.0, end: 1.6).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    index * _itervalGap, index * _itervalGap + _itervalGap))))
        .toList();
    _animationController.forward(from: 1.0);

    // _animation

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(builder: (context, constraints) {
        final itemSize = constraints.maxHeight / widget.items.length;
        final width = 100.0;
        timeDilation = 1.0;
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                if (widget.builder != null)
                  widget.builder(() {
                    _animationController.reverse();
                  }),
                if (widget.appBarBuilder != null)
                  Scaffold(
                    appBar: widget.appBarBuilder(() {
                      _animationController.reverse();
                    }),
                    body: Stack(
                      children: [
                        widget.views[_oldSelectedIndex],
                        ClipPath(
                          clipper: _MainSideMenuClipper(
                              _animationController.status ==
                                          AnimationStatus.forward &&
                                      _selectedIndex != _oldSelectedIndex &&
                                      !wasZeroIndexPressed
                                  ? Tween(begin: 0.0, end: 3.0)
                                      .animate(_animationController)
                                      .value
                                  : 3.0),
                          child: widget.views[_selectedIndex],
                        ),
                      ],
                    ),
                  ),
                for (int i = 0; i < widget.items.length; i++)
                  Positioned(
                    left: 0,
                    top: itemSize * i,
                    width: widget.menuWidth,
                    height: itemSize,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animationController.status ==
                                AnimationStatus.reverse
                            ? -_animations[widget.items.length - 1 - i].value
                            : -_animations[i].value),
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: i == _selectedIndex
                            ? widget.selectedColor
                            : widget.unselectedColor,
                        child: InkWell(
                          onTap: () {
                            _animationController.forward(from: 0.0);

                            if (i != 0) {
                              setState(() {
                                _oldSelectedIndex = _selectedIndex;
                                _selectedIndex = i;
                              });
                              wasZeroIndexPressed = false;
                            } else {
                              wasZeroIndexPressed = true;
                            }
                            widget.onItemSelected(i);
                          },
                          child: widget.items[i],
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        );
      }),
    );
  }
}

class _MainSideMenuClipper extends CustomClipper<Path> {
  final double percent;

  _MainSideMenuClipper(this.percent);
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * percent,
        height: size.height * percent,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant _MainSideMenuClipper oldClipper) =>
      oldClipper.percent != percent;
}

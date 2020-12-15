import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/skeleton_context.dart';
import '../src/skeleton_constants.dart';
import '../src/skeleton_decoration.dart';
import '../src/skeleton_theme.dart';
import '../src/skeleton_animation.dart';

class SkeletonTitle extends StatefulWidget {
  SkeletonTitle({
    Key key,
    this.pulsate: false,
    this.center: false,
    this.width,
    this.style: const SkeletonTitleStyle.origin(),
  }) : super(key: key);

  final bool pulsate;
  final bool center;
  final double width;
  final SkeletonTitleStyle style;

  @override
  _SkeletonTitleState createState() => _SkeletonTitleState();
}

class _SkeletonTitleState extends State<SkeletonTitle>
    with TickerProviderStateMixin {
  SkeletonAnimation skeletonAnimation;
  bool _animate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _animate = Provider.of<SkeletonContext>(context, listen: false).animate;
    });
    if (_animate) {
      skeletonAnimation = SkeletonAnimation(provider: this, animate: _animate);
    }
  }

  @override
  void dispose() {
    if (_animate) {
      skeletonAnimation.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return _animate
          ? AnimatedBuilder(
              animation: skeletonAnimation.gradientController,
              builder: (BuildContext context, Widget child) {
                return Opacity(
                  opacity: 1 / skeletonAnimation.pulseAnimation.value,
                  child: _content(constraints, skeletonAnimation, _animate),
                );
              },
            )
          : _content(constraints, skeletonAnimation, _animate);
    });
  }

  SkeletonDecoration _createSkeletonDecoration(animation, bool animate) {
    List<Color> colors = [];
    if (widget.style.colors != null && widget.style.colors.length > 0) {
      colors = widget.style.colors;
    } else {
      colors = Provider.of<SkeletonContext>(context, listen: false).theme !=
              SkeletonTheme.Dark
          ? lightColors
          : darkColors;
    }

    return SkeletonDecoration(
      animation: animation,
      animate: animate,
      colors: colors,
    );
  }

  Widget _content(BoxConstraints constraints, skeletonAnimation, animate) {
    var width = widget.width != null
        ? (widget.width > 1.0
            ? widget.width
            : widget.width * constraints.maxWidth)
        : constraints.maxWidth * 0.4;
    var height = widget.style.height;

    return Container(
      color: widget.style.backgroundColor,
      padding: widget.style.padding,
      margin: widget.style.margin != null
          ? widget.style.margin
          : EdgeInsets.only(bottom: height),
      child: Row(
        mainAxisAlignment: widget.center == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height,
            width: width,
            decoration: _createSkeletonDecoration(skeletonAnimation, animate),
          ),
        ],
      ),
    );
  }
}

class SkeletonTitleStyle {
  final BorderRadius borderRadius;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<Color> colors;
  final Color backgroundColor;

  SkeletonTitleStyle({
    this.borderRadius: BorderRadius.zero,
    this.height: 15.0,
    this.padding,
    this.margin,
    this.colors,
    this.backgroundColor,
  });

  const SkeletonTitleStyle.origin()
      : borderRadius = BorderRadius.zero,
        height = 15.0,
        padding = null,
        margin = null,
        colors = null,
        backgroundColor = null;
}

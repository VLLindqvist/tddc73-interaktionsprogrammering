import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/skeleton_constants.dart';
import '../src/skeleton_decoration.dart';
import '../src/skeleton_theme.dart';
import '../src/skeleton_context.dart';
import '../src/skeleton_animation.dart';

class SkeletonBox extends StatefulWidget {
  SkeletonBox({
    Key key,
    this.center: false,
    this.radius,
    this.width,
    this.height,
    this.style: const SkeletonBoxStyle.origin(),
  }) : super(key: key);

  final bool center;
  final double radius;
  final double width;
  final double height;
  final SkeletonBoxStyle style;

  @override
  _SkeletonBoxState createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
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

  SkeletonDecoration _createSkeletonDecoration(
      animation, bool animate, bool circular) {
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
      circular: circular,
      animation: animation,
      animate: animate,
      colors: colors,
    );
  }

  Widget _content(BoxConstraints constraints, skeletonAnimation, animate) {
    var radius = widget.radius != null
        ? (widget.radius > 1.0
            ? widget.radius
            : widget.radius * constraints.maxWidth)
        : constraints.maxWidth;

    var width = widget.width != null
        ? (widget.width > 1.0
            ? widget.width
            : widget.width * constraints.maxWidth)
        : constraints.maxWidth;

    var height = widget.height != null
        ? (widget.height > 1.0
            ? widget.height
            : widget.height * constraints.maxHeight)
        : (widget.width != null ? width : constraints.maxHeight);

    return Container(
      color: widget.style.backgroundColor,
      padding: widget.style.padding,
      margin: widget.style.margin,
      child: Row(
        mainAxisAlignment: widget.center == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
              height: widget.radius != null ? radius : height,
              width: widget.radius != null ? radius : width,
              decoration: _createSkeletonDecoration(
                  skeletonAnimation, animate, widget.radius != null),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonBoxStyle {
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<Color> colors;
  final Color backgroundColor;

  SkeletonBoxStyle({
    this.borderRadius: BorderRadius.zero,
    this.padding,
    this.margin,
    this.colors,
    this.backgroundColor,
  });

  const SkeletonBoxStyle.origin()
      : borderRadius = BorderRadius.zero,
        padding = null,
        margin = null,
        colors = null,
        backgroundColor = null;
}

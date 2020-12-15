import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/skeleton_context.dart';
import '../src/skeleton_constants.dart';
import '../src/skeleton_decoration.dart';
import '../src/skeleton_theme.dart';
import '../src/skeleton_animation.dart';

class SkeletonParagraph extends StatefulWidget {
  SkeletonParagraph({
    Key key,
    this.rows: 3,
    this.center: false,
    this.style: const SkeletonParagraphStyle.origin(),
  }) : super(key: key);

  final int rows;
  final bool center;
  final SkeletonParagraphStyle style;

  @override
  _SkeletonParagraphState createState() => _SkeletonParagraphState();
}

class _SkeletonParagraphState extends State<SkeletonParagraph>
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
    var width = constraints.maxWidth;
    var height = widget.style.height;

    return Container(
      color: widget.style.backgroundColor,
      padding: widget.style.padding,
      margin: widget.style.margin,
      child: Column(
        crossAxisAlignment: widget.center == true
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < widget.rows; i++)
            Container(
              height: height,
              width: i == 0 ? width : [width, width * 0.7, width * 0.9][i % 3],
              decoration: _createSkeletonDecoration(skeletonAnimation, animate),
              // all rows except last has bottom margin
              margin: i < widget.rows - 1
                  ? EdgeInsets.only(bottom: height)
                  : EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}

class SkeletonParagraphStyle {
  final BorderRadius borderRadius;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final List<Color> colors;
  final Color backgroundColor;

  SkeletonParagraphStyle({
    this.borderRadius: BorderRadius.zero,
    this.height: 10.0,
    this.padding,
    this.margin,
    this.colors,
    this.backgroundColor,
  });

  const SkeletonParagraphStyle.origin()
      : borderRadius = BorderRadius.zero,
        height = 10.0,
        padding = null,
        margin = null,
        colors = null,
        backgroundColor = null;
}

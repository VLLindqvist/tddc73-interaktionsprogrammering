import 'package:flutter/material.dart';

import 'skeleton_paragraph.dart';
import 'skeleton_title.dart';
import 'skeleton_box.dart';

class SkeletonPlaceholder extends StatefulWidget {
  SkeletonPlaceholder({
    Key key,
    this.child,
    this.margin: EdgeInsets.zero,
    this.padding: EdgeInsets.zero,
    this.title: true,
    this.avatar: false,
    this.style: const SkeletonPlaceholderStyle.origin(),
  }) : super(key: key);

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool title;
  final bool avatar;
  final SkeletonPlaceholderStyle style;

  @override
  _SkeletonPlaceholderState createState() => _SkeletonPlaceholderState();
}

class _SkeletonPlaceholderState extends State<SkeletonPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = widget.style.width != null
          ? (widget.style.width > 1.0
              ? widget.style.width
              : constraints.maxWidth * widget.style.width)
          : constraints.maxWidth;

      final height = widget.style.height != null
          ? (widget.style.height > 1.0
              ? widget.style.height
              : constraints.maxHeight * widget.style.height)
          : null;

      var child = widget.child;

      if (widget.child == null) {
        child = Row(
          children: <Widget>[
            if (widget.avatar == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SkeletonBox(
                    radius: width * 0.15,
                  ),
                  VerticalDivider(
                    width: width * 0.20,
                  ),
                ],
              ),
            Expanded(
              child: Column(
                children: [
                  if (widget.title == true) SkeletonTitle(),
                  SkeletonParagraph(
                    rows: 3,
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return Container(
        width: width,
        height: height,
        margin: widget.margin,
        padding: widget.padding,
        child: child,
      );
    });
  }
}

class SkeletonPlaceholderStyle {
  final bool pulsate;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final List<Color> colors;
  final Color backgroundColor;
  final double width;
  final double height;

  SkeletonPlaceholderStyle({
    this.pulsate: true,
    this.borderRadius: BorderRadius.zero,
    this.padding: const EdgeInsets.all(16.0),
    this.colors,
    this.backgroundColor,
    this.width,
    this.height,
  });

  const SkeletonPlaceholderStyle.origin()
      : pulsate = false,
        borderRadius = BorderRadius.zero,
        padding = const EdgeInsets.all(16.0),
        colors = null,
        backgroundColor = null,
        width = null,
        height = null;
}

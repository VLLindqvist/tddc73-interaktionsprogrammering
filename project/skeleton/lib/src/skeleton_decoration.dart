import 'package:flutter/material.dart';
import 'skeleton_animation.dart';

class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    @required List<Color> colors,
    animate: false,
    SkeletonAnimation animation,
    circular: false,
  }) : super(
          shape: circular ? BoxShape.circle : BoxShape.rectangle,
          color: animate ? null : colors[0],
          gradient: animate
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: colors,
                  stops: [
                    animation.gradientAnimation.value - 1,
                    animation.gradientAnimation.value,
                    animation.gradientAnimation.value + 1
                  ],
                )
              : null,
          borderRadius: circular
              ? null
              : BorderRadius.all(
                  Radius.circular(
                    animate ? 1.0 * animation.pulseAnimation.value : 3.0,
                  ),
                ),
          // border: Border.all(
          //         color: Color, width: pulseAnimation.value * 1),
        );
}

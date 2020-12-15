import 'package:flutter/material.dart';

import 'skeleton_theme.dart';

class SkeletonContext extends ChangeNotifier {
  SkeletonContext({
    @required this.theme,
    this.animate,
  });

  final SkeletonTheme theme;
  final bool animate;
}

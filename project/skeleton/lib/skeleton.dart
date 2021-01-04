library skeleton;

export 'widgets/skeleton_box.dart';
export 'widgets/skeleton_title.dart';
export 'widgets/skeleton_paragraph.dart';
export 'widgets/skeleton_placeholder.dart';
export 'src/skeleton_theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/skeleton_context.dart';
import 'src/skeleton_theme.dart';
import 'widgets/skeleton_placeholder.dart';

/// The main handler for skeletons.
/// Takes in

class Skeleton extends StatelessWidget {
  Skeleton({
    Key key,
    @required this.loading,
    @required this.child,
    this.placeholder,
    this.theme: SkeletonTheme.Light,
    this.animate: true,
  }) : super(key: key);

  final bool loading;
  final Widget child;
  final SkeletonPlaceholder placeholder;
  final SkeletonTheme theme;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SkeletonContext(
        theme: theme,
        animate: animate,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: loading
            ? (placeholder != null ? placeholder : SkeletonPlaceholder())
            : child,
      ),
    );
  }
}

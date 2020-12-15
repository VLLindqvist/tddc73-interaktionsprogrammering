import 'package:flutter/material.dart';

class SkeletonAnimation {
  AnimationController _gradientController;
  AnimationController _pulseController;
  Animation<double> gradientAnimation;
  Animation<double> pulseAnimation;
  final bool animate;
  final TickerProvider provider;
  final Duration pulseDuration;
  final Duration gradientDuration;

  SkeletonAnimation({
    this.provider,
    this.animate,
    this.gradientDuration: const Duration(milliseconds: 1200),
    this.pulseDuration: const Duration(milliseconds: 1100),
  }) {
    _gradientController =
        AnimationController(vsync: provider, duration: gradientDuration);

    _pulseController =
        AnimationController(vsync: provider, duration: pulseDuration);

    if (animate) {
      gradientAnimation =
          Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(
        curve: Curves.easeInOutSine,
        parent: _gradientController,
      ));

      gradientAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _gradientController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _gradientController.forward();
        }
      });
      _gradientController.forward();

      pulseAnimation =
          Tween<double>(begin: 1.0, end: 3.5).animate(CurvedAnimation(
        curve: Curves.easeInSine,
        parent: _pulseController,
      ));

      pulseAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _pulseController.forward();
        }
      });
      _pulseController.forward();
    }
  }

  get gradientController => _gradientController;
  get pulseController => _pulseController;

  void dispose() {
    _gradientController.dispose();
    _pulseController.dispose();
  }
}

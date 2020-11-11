import 'package:flutter/material.dart';

class CollapseAnimation extends AnimatedWidget {
  CollapseAnimation({key, animation, this.child})
      : super(
    key: key,
    listenable: animation,
  );

  final Widget child;
  final Tween tween = Tween<double>(begin: 0, end: 96);

  @override
  StatefulElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;

    var animationValue = tween.evaluate(animation);
    double height = animationValue >= 0.0 ? animationValue : 0.0;
    return Container(
      height: height,
      child: child,
    );
  }
}
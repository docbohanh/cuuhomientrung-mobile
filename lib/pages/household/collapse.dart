import 'package:flutter/material.dart';

class CollapseAnimation extends AnimatedWidget {
  CollapseAnimation({key, animation, this.child})
      : super(
    key: key,
    listenable: animation,
  );

  final Widget child;

  @override
  StatefulElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    Tween tween = Tween<double>(begin: 0, end: MediaQuery.of(context).size.width);

    var animationValue = tween.evaluate(animation);
    double width = animationValue >= 0.0 ? animationValue : 0.0;
    return Container(
      width: width,
      child: child,
    );
  }
}
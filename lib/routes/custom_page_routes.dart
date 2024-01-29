import 'package:flutter/material.dart';

class FadeInPageRouteTransition<T> extends PageRoute<T> {
  FadeInPageRouteTransition(this.child);
  @override
  Color get barrierColor => Colors.purple;

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(seconds: 2);
}

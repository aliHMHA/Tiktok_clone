import 'package:flutter/material.dart';

class CircilAnimation extends StatefulWidget {
  final Widget child;
  const CircilAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<CircilAnimation> createState() => _CircilAnimationState();
}

class _CircilAnimationState extends State<CircilAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));

    _controller.forward();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}

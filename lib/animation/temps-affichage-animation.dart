import 'package:flutter/material.dart';
import 'dart:async';

class TempsAnimation extends StatefulWidget {
  final Widget child;
  final int delai;
  const TempsAnimation({super.key, required this.child, required this.delai});

  @override
  State<TempsAnimation> createState() => _TempsAnimationState();
}

class _TempsAnimationState extends State<TempsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );

    _animOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delai), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _controller,
        child: SlideTransition(position: _animOffset, child: widget.child));
  }
}

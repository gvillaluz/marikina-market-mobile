import 'package:flutter/material.dart';

class SkeletonBox extends StatefulWidget {
  final double height;
  const SkeletonBox({
    required this.height,
    super.key
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: Colors.grey.shade100,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) => Container(
        height: widget.height,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
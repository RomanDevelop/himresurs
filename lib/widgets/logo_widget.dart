import 'package:flutter/material.dart';
import '../widgets/logo_painter.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showShadow;

  const LogoWidget({
    Key? key,
    this.size = 120,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: CustomPaint(
        painter: ChemresursLogoPainter(),
        size: Size(size, size),
      ),
    );
  }
}

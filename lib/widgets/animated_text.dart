import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const AnimatedText({
    Key? key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
  }) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _letterAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Создаем анимацию для каждой буквы с небольшим смещением
    _letterAnimations = List.generate(
      widget.text.length,
      (index) {
        final startInterval = index / widget.text.length;
        final endInterval = (index + 1) / widget.text.length;

        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              startInterval,
              endInterval,
              curve: widget.curve,
            ),
          ),
        );
      },
    );

    // Запускаем анимацию с задержкой
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final characters = widget.text.characters.toList();

        return Center(
          child: Text.rich(
            TextSpan(
              children: List.generate(
                characters.length,
                (index) {
                  return WidgetSpan(
                    child: Opacity(
                      opacity: _letterAnimations[index].value,
                      child: Transform.translate(
                        offset: Offset(
                            0, 20 * (1 - _letterAnimations[index].value)),
                        child: Text(
                          characters[index],
                          style: widget.style,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

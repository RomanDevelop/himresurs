import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChemresursLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Определяем основные цвета в корпоративном стиле
    final primaryGreen = const Color(0xFF00563F);
    final secondaryGreen = const Color(0xFF3C8C6C);
    final lightGreen = const Color(0xFF6BAF92);

    // Рассчитываем центр и размеры
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.4;

    // Рисуем фоновый круг для логотипа
    final bgPaint = Paint()
      ..color = primaryGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, bgPaint);

    // Создаем внешнюю границу круга
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(Offset(centerX, centerY), radius, strokePaint);

    // Внутренний круг для эффекта глубины
    final innerCirclePaint = Paint()
      ..color = secondaryGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(centerX, centerY), radius * 0.75, innerCirclePaint);

    // Рисуем колбу - символ химической промышленности
    _drawFlask(canvas, centerX, centerY, radius);

    // Добавляем блик для эффекта глянца
    _drawHighlight(canvas, centerX, centerY, radius);
  }

  // Метод для отрисовки колбы
  void _drawFlask(
      Canvas canvas, double centerX, double centerY, double radius) {
    final flaskPath = Path();
    final flaskTop = centerY - radius * 0.5;
    final flaskBottom = centerY + radius * 0.4;
    final flaskNeck = centerY - radius * 0.2;
    final flaskWidth = radius * 0.7;

    // Левая сторона горлышка
    flaskPath.moveTo(centerX - flaskWidth * 0.15, flaskTop);
    flaskPath.lineTo(centerX - flaskWidth * 0.15, flaskNeck);

    // Левая сторона колбы
    flaskPath.quadraticBezierTo(
        centerX - flaskWidth * 0.2,
        flaskNeck + radius * 0.1,
        centerX - flaskWidth * 0.4,
        flaskNeck + radius * 0.15);
    flaskPath.lineTo(centerX - flaskWidth * 0.5, flaskBottom);

    // Нижняя часть колбы
    flaskPath.quadraticBezierTo(centerX, flaskBottom + radius * 0.1,
        centerX + flaskWidth * 0.5, flaskBottom);

    // Правая сторона колбы
    flaskPath.lineTo(centerX + flaskWidth * 0.4, flaskNeck + radius * 0.15);
    flaskPath.quadraticBezierTo(centerX + flaskWidth * 0.2,
        flaskNeck + radius * 0.1, centerX + flaskWidth * 0.15, flaskNeck);

    // Правая сторона горлышка
    flaskPath.lineTo(centerX + flaskWidth * 0.15, flaskTop);
    flaskPath.close();

    // Рисуем колбу
    final flaskPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawPath(flaskPath, flaskPaint);

    // Обводка колбы
    final flaskStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(flaskPath, flaskStrokePaint);

    // Добавляем жидкость в колбу
    _drawLiquid(canvas, centerX, centerY, radius, flaskPath);

    // Добавляем пузырьки
    _drawBubbles(canvas, centerX, centerY, radius);
  }

  // Метод для отрисовки жидкости в колбе
  void _drawLiquid(Canvas canvas, double centerX, double centerY, double radius,
      Path flaskPath) {
    final liquidPath = Path();
    final liquidLevel = centerY + radius * 0.1; // Уровень жидкости
    final flaskBottom = centerY + radius * 0.4;
    final flaskWidth = radius * 0.7;

    // Линия уровня жидкости
    liquidPath.moveTo(centerX - flaskWidth * 0.35, liquidLevel);

    // Волнистая поверхность жидкости
    liquidPath.quadraticBezierTo(centerX - flaskWidth * 0.15,
        liquidLevel - radius * 0.05, centerX, liquidLevel);
    liquidPath.quadraticBezierTo(centerX + flaskWidth * 0.15,
        liquidLevel + radius * 0.05, centerX + flaskWidth * 0.35, liquidLevel);

    // Нижняя часть жидкости (повторяет форму колбы)
    liquidPath.lineTo(centerX + flaskWidth * 0.5, flaskBottom);
    liquidPath.quadraticBezierTo(centerX, flaskBottom + radius * 0.1,
        centerX - flaskWidth * 0.5, flaskBottom);
    liquidPath.lineTo(centerX - flaskWidth * 0.35, liquidLevel);
    liquidPath.close();

    // Применяем пересечение с формой колбы
    final liquidClipPath =
        Path.combine(PathOperation.intersect, flaskPath, liquidPath);

    // Рисуем жидкость
    final liquidPaint = Paint()
      ..color = const Color(0xFF6BAF92) // Светло-зеленая жидкость
      ..style = PaintingStyle.fill;
    canvas.drawPath(liquidClipPath, liquidPaint);
  }

  // Метод для рисования пузырьков в колбе
  void _drawBubbles(
      Canvas canvas, double centerX, double centerY, double radius) {
    final random = math.Random(42); // Фиксированный seed для повторяемости
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Рисуем несколько пузырьков разного размера
    for (int i = 0; i < 6; i++) {
      final bubbleSize = radius * (0.05 + random.nextDouble() * 0.08);
      final xOffset = (random.nextDouble() * 0.6 - 0.3) * radius;
      final yOffset = (random.nextDouble() * 0.6) * radius;

      canvas.drawCircle(Offset(centerX + xOffset, centerY + yOffset),
          bubbleSize, bubblePaint);
    }
  }

  // Метод для рисования блика
  void _drawHighlight(
      Canvas canvas, double centerX, double centerY, double radius) {
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(centerX - radius * 0.2, centerY - radius * 0.2),
            width: radius * 1.2,
            height: radius * 1.2),
        math.pi * 0.8,
        math.pi * 0.7,
        false,
        highlightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

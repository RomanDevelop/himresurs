import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Провайдер для управления состоянием сохранения скриншота
final screenshotProvider = StateProvider<Uint8List?>((ref) => null);

// Провайдер для отслеживания процесса создания скриншота
final isCapturingProvider = StateProvider<bool>((ref) => false);

class RepaintBoundaryContainer extends ConsumerStatefulWidget {
  final Widget child;
  final GlobalKey repaintBoundaryKey;

  const RepaintBoundaryContainer({
    Key? key,
    required this.child,
    required this.repaintBoundaryKey,
  }) : super(key: key);

  @override
  ConsumerState<RepaintBoundaryContainer> createState() =>
      _RepaintBoundaryContainerState();
}

class _RepaintBoundaryContainerState
    extends ConsumerState<RepaintBoundaryContainer> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.repaintBoundaryKey,
      child: widget.child,
    );
  }

  // Метод для создания снимка экрана с использованием Riverpod
  Future<void> captureScreenshot() async {
    try {
      // Устанавливаем флаг, что идет захват скриншота
      ref.read(isCapturingProvider.notifier).state = true;

      RenderRepaintBoundary boundary = widget.repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Сохраняем результат в провайдер
      ref.read(screenshotProvider.notifier).state = pngBytes;
      ref.read(isCapturingProvider.notifier).state = false;
    } catch (e) {
      ref.read(isCapturingProvider.notifier).state = false;
      debugPrint('Ошибка при создании снимка экрана: $e');
    }
  }
}

// Вспомогательный виджет для обертывания любого другого виджета в RepaintBoundary
class RepaintBoundaryWrapper extends StatelessWidget {
  final Widget child;
  final bool withBorder;

  const RepaintBoundaryWrapper({
    Key? key,
    required this.child,
    this.withBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: withBorder
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              child: child,
            )
          : child,
    );
  }
}

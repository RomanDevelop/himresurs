import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../widgets/repaint_boundary_container.dart';
import '../data/products_data.dart';
import '../configs/app_config.dart';
import '../widgets/network_image_widget.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);

    return RepaintBoundaryContainer(
      repaintBoundaryKey: _repaintBoundaryKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: RepaintBoundaryWrapper(
            child: AppBar(
              title: const Text('Продукция'),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return RepaintBoundaryWrapper(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ref.read(selectedProductProvider.notifier).state = product;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Изображение продукта
                      Container(
                        height: 180,
                        width: double.infinity,
                        child: RepaintBoundaryWrapper(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: _getProductVisualWidget(product.id),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Информация о продукте
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Краткое описание
                            RepaintBoundaryWrapper(
                              child: Text(
                                product.description.length > 120
                                    ? '${product.description.substring(0, 120)}...'
                                    : product.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Примеры применения
                            const RepaintBoundaryWrapper(
                              child: Text(
                                'Применение:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...product.applications
                                .take(2)
                                .map((application) => RepaintBoundaryWrapper(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.arrow_right,
                                                color: Colors.blue, size: 18),
                                            Expanded(
                                              child: Text(
                                                application.length > 70
                                                    ? '${application.substring(0, 70)}...'
                                                    : application,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),

                            // Кнопка подробнее
                            Align(
                              alignment: Alignment.centerRight,
                              child: RepaintBoundaryWrapper(
                                child: TextButton.icon(
                                  onPressed: () {
                                    ref
                                        .read(selectedProductProvider.notifier)
                                        .state = product;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                product: product),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.read_more),
                                  label: const Text('Подробнее'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Получаем визуальное представление продукта для списка
  Widget _getProductVisualWidget(String productId) {
    CustomPainter painter;

    switch (productId) {
      case '1': // Стеарат кальция
        painter = CalciumStearateModelPainter();
        break;
      case '2': // Стеарат магния
        painter = MagnesiumStearateModelPainter();
        break;
      case '3': // Стеарат цинка
        painter = ZincStearateModelPainter();
        break;
      default:
        return Image.asset(
          _getProductImagePath(productId),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
    }

    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: painter,
        size: const Size(double.infinity, 180),
        isComplex: true,
      ),
    );
  }

  // Получаем путь к изображению продукта на основе его ID
  String _getProductImagePath(String productId) {
    switch (productId) {
      case 'calcium_stearate':
        return AppConfig.calciumStearateImage;
      case 'magnesium_stearate':
        return AppConfig.magnesiumStearateImage;
      case 'zinc_stearate':
        return AppConfig.zincStearateImage;
      default:
        return AppConfig.defaultProductImage;
    }
  }
}

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundaryContainer(
      repaintBoundaryKey: _repaintBoundaryKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: RepaintBoundaryWrapper(
            child: AppBar(
              title: Text(widget.product.name),
              backgroundColor: AppConfig.appThemeColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Изображение продукта с названием
              RepaintBoundaryWrapper(
                child: Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: _getProductVisual(widget.product.id),
                    ),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Содержимое
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Описание продукта
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('Описание'),
                    ),
                    const SizedBox(height: 8),
                    RepaintBoundaryWrapper(
                      child: Text(
                        widget.product.description,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Области применения
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('Области применения'),
                    ),
                    const SizedBox(height: 16),
                    RepaintBoundaryWrapper(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: widget.product.applications
                              .map((application) => RepaintBoundaryWrapper(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              application,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Кнопки действий
                    RepaintBoundaryWrapper(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.phone,
                            label: 'Связаться',
                            onPressed: () {
                              Navigator.pushNamed(context, '/contact');
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.shopping_cart,
                            label: 'Заказать',
                            primary: true,
                            onPressed: () {
                              Navigator.pushNamed(context, '/contact');
                            },
                          ),
                          _buildActionButton(
                            icon: Icons.local_shipping,
                            label: 'Доставка',
                            onPressed: () {
                              Navigator.pushNamed(context, '/delivery');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return RepaintBoundaryWrapper(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          foregroundColor: primary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  // Получаем визуальное представление продукта на основе его ID
  Widget _getProductVisual(String productId) {
    CustomPainter painter;

    switch (productId) {
      case '1': // Стеарат кальция
        painter = CalciumStearateModelPainter();
        break;
      case '2': // Стеарат магния
        painter = MagnesiumStearateModelPainter();
        break;
      case '3': // Стеарат цинка
        painter = ZincStearateModelPainter();
        break;
      default:
        // Возвращаем обычное изображение если нет кастомного отрисовщика
        return Image.asset(
          _getProductImagePath(productId),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              height: 250,
              width: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
    }

    // Возвращаем CustomPaint с соответствующим отрисовщиком
    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: painter,
        size: const Size(double.infinity, 250),
        isComplex: true,
      ),
    );
  }

  // Получаем путь к изображению продукта на основе его ID
  String _getProductImagePath(String productId) {
    switch (productId) {
      case 'calcium_stearate':
        return AppConfig.calciumStearateImage;
      case 'magnesium_stearate':
        return AppConfig.magnesiumStearateImage;
      case 'zinc_stearate':
        return AppConfig.zincStearateImage;
      default:
        return AppConfig.defaultProductImage;
    }
  }
}

// Классы для рисования стеаратов
class CalciumStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.12;

    // Рисуем фон
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Рисуем концентрические окружности
    for (int i = 5; i > 0; i--) {
      final circlePaint = Paint()
        ..color = Colors.grey[800]!.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(
        Offset(centerX, centerY),
        radius * i * 1.5,
        circlePaint,
      );
    }

    // Рисуем молекулы воды/атомы кислорода вокруг кальция
    final random = Random(42); // Фиксированный seed для постоянного результата
    for (int i = 0; i < 10; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final distance = random.nextDouble() * radius * 5 + radius * 2;
      final x = centerX + cos(angle) * distance;
      final y = centerY + sin(angle) * distance;

      final atomRadius = radius * (0.3 + random.nextDouble() * 0.2);
      final atomPaint = Paint()
        ..color = Colors.lightBlue[300]!.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), atomRadius, atomPaint);
    }

    // Рисуем центральное изображение кальция стеарата (желтоватый порошок)
    final centerCirclePaint = Paint()
      ..color = const Color(0xFFF8F0C6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius * 2,
      centerCirclePaint,
    );

    // Создаем текстуру порошка с мелкими частицами
    final random2 = Random(12);
    for (int i = 0; i < 80; i++) {
      final angle = random2.nextDouble() * 2 * pi;
      final distance = random2.nextDouble() * radius * 1.8;
      final x = centerX + cos(angle) * distance;
      final y = centerY + sin(angle) * distance;

      final particleRadius = radius * (0.05 + random2.nextDouble() * 0.12);
      final particlePaint = Paint()
        ..color = Color.fromRGBO(
          240 + random2.nextInt(15),
          234 + random2.nextInt(20),
          170 + random2.nextInt(30),
          0.9,
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleRadius, particlePaint);
    }

    // Добавляем надпись "Ca" внизу
    final textStyle = TextStyle(
      color: Colors.black87,
      fontSize: radius,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: 'Ca',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY + radius * 2.5,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MagnesiumStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final unitSize = size.width * 0.08;

    // Темный фон
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Рисуем кристаллическую решетку
    final gridPaint = Paint()
      ..color = Colors.grey[600]!.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Вертикальные и горизонтальные линии сетки
    for (int i = 0; i < 11; i++) {
      final pos = i * unitSize * 1.5 + centerX - unitSize * 7.5;
      canvas.drawLine(
        Offset(pos, centerY - unitSize * 5),
        Offset(pos, centerY + unitSize * 5),
        gridPaint,
      );

      canvas.drawLine(
        Offset(centerX - unitSize * 7.5, centerY - unitSize * 5 + i * unitSize),
        Offset(centerX + unitSize * 7.5, centerY - unitSize * 5 + i * unitSize),
        gridPaint,
      );
    }

    // Рисуем структуру кристаллической решетки магния
    final mgGrid = 5;
    final mgRadius = unitSize * 0.5;

    // Рисуем узлы кристаллической решетки (атомы Mg)
    for (int i = -mgGrid; i <= mgGrid; i += 2) {
      for (int j = -mgGrid; j <= mgGrid; j += 2) {
        final x = centerX + i * unitSize;
        final y = centerY + j * unitSize;

        final atomPaint = Paint()
          ..color = const Color(0xFF4CAF50).withOpacity(0.6)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), mgRadius, atomPaint);
      }
    }

    // Центральный магний (больше размером)
    final centerMgPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, centerY),
      unitSize * 1.5,
      centerMgPaint,
    );

    // Блик на центральном магнии
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX - unitSize * 0.5, centerY - unitSize * 0.5),
      unitSize * 0.5,
      highlightPaint,
    );

    // Текст символа для основного магния
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: unitSize * 1.5,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: 'Mg',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ZincStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.1;

    // Светлый фон
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Рисуем сетку из шестиугольников
    final gridPaint = Paint()
      ..color = Colors.blue[900]!.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Рисуем шестиугольную сетку
    _drawHexagonalGrid(canvas, size, gridPaint);

    // Рисуем атомы цинка, соединенные в структуру
    final zincPositions = [
      Offset(centerX - radius * 4, centerY - radius * 2),
      Offset(centerX - radius * 2, centerY - radius * 4),
      Offset(centerX + radius * 2, centerY - radius * 4),
      Offset(centerX + radius * 4, centerY - radius * 2),
      Offset(centerX + radius * 4, centerY + radius * 2),
      Offset(centerX + radius * 2, centerY + radius * 4),
      Offset(centerX - radius * 2, centerY + radius * 4),
      Offset(centerX - radius * 4, centerY + radius * 2),
    ];

    // Рисуем соединительные линии между атомами цинка
    final connectionPaint = Paint()
      ..color = Colors.blue[700]!.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < zincPositions.length; i++) {
      final start = zincPositions[i];
      final end = zincPositions[(i + 1) % zincPositions.length];
      canvas.drawLine(start, end, connectionPaint);

      // Также соединяем с центром
      canvas.drawLine(start, Offset(centerX, centerY), connectionPaint);
    }

    // Рисуем атомы цинка в сетке
    for (final position in zincPositions) {
      _drawZincAtom(canvas, position, radius * 0.8);
    }

    // Рисуем центральный, более крупный атом цинка
    _drawZincAtom(canvas, Offset(centerX, centerY), radius * 2, true);
  }

  void _drawHexagonalGrid(Canvas canvas, Size size, Paint paint) {
    final hexSize = size.width * 0.08;
    final rows = 12;
    final cols = 8;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final xOffset = col * hexSize * 1.5;
        final yOffset = row * hexSize * sqrt(3) +
            (col % 2 == 0 ? 0 : hexSize * sqrt(3) / 2);

        final centerX = xOffset;
        final centerY = yOffset;

        _drawHexagon(canvas, Offset(centerX, centerY), hexSize, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * pi / 180;
      final x = center.dx + size * cos(angle);
      final y = center.dy + size * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawZincAtom(Canvas canvas, Offset center, double radius,
      [bool isCenter = false]) {
    // Базовый цвет атома цинка (голубой)
    final baseColor = isCenter ? Colors.blue[500]! : Colors.blue[400]!;

    // Градиент для 3D эффекта
    final gradient = RadialGradient(
      colors: [
        Colors.white.withOpacity(0.8),
        baseColor,
        Colors.blue[800]!.withOpacity(0.7),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()..style = PaintingStyle.fill;
    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawCircle(center, radius, paint);

    // Блик для 3D эффекта
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final highlightRadius = isCenter ? radius * 0.4 : radius * 0.3;
    final highlightOffset = isCenter ? radius * 0.3 : radius * 0.2;

    canvas.drawCircle(
      Offset(center.dx - highlightOffset, center.dy - highlightOffset),
      highlightRadius,
      highlightPaint,
    );

    // Добавляем символ Zn только для центрального атома
    if (isCenter) {
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: radius * 0.8,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: 'Zn',
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../widgets/repaint_boundary_container.dart';
import '../data/company_data.dart';
import '../configs/app_config.dart';

// Провайдер для текущей страницы слайдера
final currentPageProvider = StateProvider<int>((ref) => 0);

// Провайдер списка изображений
final imageListProvider = Provider<List<String>>((ref) => [
      AppConfig.slider1Image,
      AppConfig.slider2Image,
      AppConfig.slider3Image,
    ]);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _pageController.hasClients) {
        final currentPage = ref.read(currentPageProvider);
        final imageList = ref.read(imageListProvider);

        _pageController.animateToPage(
          (currentPage + 1) % imageList.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      } else if (mounted) {
        // Если контроллер не привязан, повторно запускаем через короткое время
        Future.delayed(const Duration(milliseconds: 200), _startAutoScroll);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageList = ref.watch(imageListProvider);
    final currentPage = ref.watch(currentPageProvider);

    return RepaintBoundaryContainer(
      repaintBoundaryKey: _repaintBoundaryKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: RepaintBoundaryWrapper(
            child: AppBar(
              title: const Text(AppConfig.appName),
              centerTitle: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Логотип
              RepaintBoundaryWrapper(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: CustomPaint(
                        painter: MoleculeModelPainter(),
                      ),
                    ),
                  ),
                ),
              ),

              // Приветствие
              RepaintBoundaryWrapper(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Добро пожаловать!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CompanyData.shortDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Слайдер (карусель изображений)
              RepaintBoundaryWrapper(
                child: SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    onPageChanged: (index) {
                      ref.read(currentPageProvider.notifier).state = index;
                    },
                    itemBuilder: (context, index) {
                      final sliderImages = [
                        AppConfig.slider1Image,
                        AppConfig.slider2Image,
                        AppConfig.slider3Image,
                      ];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RepaintBoundaryWrapper(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              sliderImages[index],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Theme.of(context).primaryColor,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Преимущества компании
              RepaintBoundaryWrapper(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Наши преимущества',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...CompanyData.advantages.map(
                            (advantage) => RepaintBoundaryWrapper(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(advantage)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Краткая информация о компании
              RepaintBoundaryWrapper(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'О компании',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CompanyData.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          RepaintBoundaryWrapper(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/about');
                              },
                              child: const Text('Подробнее о компании'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Продукция компании
              RepaintBoundaryWrapper(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Наша продукция',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          // Карточка продукта 1
                          RepaintBoundaryWrapper(
                            child: _buildChemicalCard(
                              context,
                              'Кальций стеарат',
                              CalciumStearateModelPainter(),
                              () {
                                Navigator.pushNamed(
                                    context, '/products/calcium_stearate');
                              },
                            ),
                          ),
                          // Карточка продукта 2
                          RepaintBoundaryWrapper(
                            child: _buildChemicalCard(
                              context,
                              'Магний стеарат',
                              MagnesiumStearateModelPainter(),
                              () {
                                Navigator.pushNamed(
                                    context, '/products/magnesium_stearate');
                              },
                            ),
                          ),
                          // Карточка продукта 3
                          RepaintBoundaryWrapper(
                            child: _buildChemicalCard(
                              context,
                              'Цинк стеарат',
                              ZincStearateModelPainter(),
                              () {
                                Navigator.pushNamed(
                                    context, '/products/zinc_stearate');
                              },
                            ),
                          ),
                          // Кнопка "Все продукты"
                          RepaintBoundaryWrapper(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/products');
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.view_list,
                                          size: 40,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Все продукты',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет для карточки продукта
  Widget _buildChemicalCard(BuildContext context, String title,
      CustomPainter painter, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  child: CustomPaint(
                    painter: painter,
                    isComplex: true,
                    willChange: false,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Добавляем класс для рисования 3D модели химической молекулы
class MoleculeModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 3;

    // Рисуем атомы и связи
    _drawAtom(
        canvas, Offset(centerX, centerY), radius * 0.8, Colors.blue.shade700);

    // Орбиты электронов
    _drawElectronOrbit(canvas, Offset(centerX, centerY), radius, 0, 30);
    _drawElectronOrbit(canvas, Offset(centerX, centerY), radius, 60, 15);
    _drawElectronOrbit(canvas, Offset(centerX, centerY), radius, 120, 45);

    // Электроны (частицы) на орбитах
    _drawElectron(canvas,
        Offset(centerX + radius * 0.7, centerY - radius * 0.4), radius * 0.15);
    _drawElectron(canvas,
        Offset(centerX - radius * 0.5, centerY + radius * 0.6), radius * 0.15);
    _drawElectron(canvas,
        Offset(centerX + radius * 0.2, centerY + radius * 0.7), radius * 0.15);
  }

  void _drawAtom(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Градиент для 3D эффекта
    final gradient = RadialGradient(
      colors: [color.withOpacity(0.8), color, Colors.black.withOpacity(0.5)],
      stops: const [0.0, 0.5, 1.0],
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawCircle(center, radius, paint);

    // Блик для 3D эффекта
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.25,
      highlightPaint,
    );
  }

  void _drawElectronOrbit(Canvas canvas, Offset center, double radius,
      double rotationDegree, double tiltDegree) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDegree * 3.14 / 180);

    // Наклон для создания 3D эффекта
    final oval = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2,
      height: radius *
          2 *
          (1 - tiltDegree / 100), // Сжимаем по вертикали для эффекта наклона
    );

    canvas.drawOval(oval, paint);
    canvas.restore();
  }

  void _drawElectron(Canvas canvas, Offset position, double radius) {
    // Градиент для электрона
    final gradient = RadialGradient(
      colors: [
        Colors.cyan.shade400,
        Colors.cyan.shade700,
      ],
    );

    final paint = Paint()..style = PaintingStyle.fill;

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: position, radius: radius),
    );

    canvas.drawCircle(position, radius, paint);

    // Блик на электроне
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(position.dx - radius * 0.3, position.dy - radius * 0.3),
      radius * 0.4,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Классы для рисования молекул стеаратов

// Кальций стеарат - показываем структуру с ионом кальция
class CalciumStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.15;

    // Рисуем основную структуру
    final structurePaint = Paint()
      ..color = const Color(0xFF0D6E6E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Рисуем шестиугольники (представляющие часть жирной кислоты)
    _drawHexagon(canvas, Offset(centerX - radius * 2, centerY), radius * 0.8,
        structurePaint);
    _drawHexagon(canvas, Offset(centerX, centerY - radius), radius * 0.8,
        structurePaint);
    _drawHexagon(canvas, Offset(centerX + radius * 2, centerY), radius * 0.8,
        structurePaint);

    // Линии, соединяющие шестиугольники
    canvas.drawLine(
      Offset(centerX - radius * 1.4, centerY - radius * 0.4),
      Offset(centerX - radius * 0.6, centerY - radius * 0.7),
      structurePaint,
    );

    canvas.drawLine(
      Offset(centerX + radius * 0.6, centerY - radius * 0.7),
      Offset(centerX + radius * 1.4, centerY - radius * 0.4),
      structurePaint,
    );

    // Рисуем ион кальция в центре
    _drawIon(canvas, Offset(centerX, centerY + radius), radius * 1.2,
        const Color(0xFF6589A9), 'Ca');
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawIon(
      Canvas canvas, Offset center, double radius, Color color, String symbol) {
    // Рисуем атом
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Обводка атома
    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius, strokePaint);

    // Текст символа элемента
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: radius * 1.2,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: symbol,
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Магний стеарат - показываем кристаллическую решетку
class MagnesiumStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final unitSize = size.width * 0.2;

    // Рисуем кристаллическую решетку
    final latticeLinePaint = Paint()
      ..color = const Color(0xFF39A275)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Горизонтальные линии
    for (int i = 0; i < 4; i++) {
      final y = centerY - unitSize + i * unitSize * 0.7;
      canvas.drawLine(
        Offset(centerX - unitSize * 1.5, y),
        Offset(centerX + unitSize * 1.5, y),
        latticeLinePaint,
      );
    }

    // Вертикальные линии
    for (int i = 0; i < 4; i++) {
      final x = centerX - unitSize * 1.5 + i * unitSize;
      canvas.drawLine(
        Offset(x, centerY - unitSize),
        Offset(x, centerY + unitSize * 1.1),
        latticeLinePaint,
      );
    }

    // Рисуем атомы в узлах решетки
    final nodePositions = [
      Offset(centerX - unitSize * 1.5, centerY - unitSize),
      Offset(centerX - unitSize * 0.5, centerY - unitSize),
      Offset(centerX + unitSize * 0.5, centerY - unitSize),
      Offset(centerX - unitSize * 1.0, centerY - unitSize * 0.3),
      Offset(centerX, centerY - unitSize * 0.3),
      Offset(centerX + unitSize, centerY - unitSize * 0.3),
      Offset(centerX - unitSize * 1.5, centerY + unitSize * 0.4),
      Offset(centerX - unitSize * 0.5, centerY + unitSize * 0.4),
      Offset(centerX + unitSize * 0.5, centerY + unitSize * 0.4),
      Offset(centerX - unitSize, centerY + unitSize * 1.1),
      Offset(centerX, centerY + unitSize * 1.1),
      Offset(centerX + unitSize, centerY + unitSize * 1.1),
    ];

    // Магний - центральный атом, больше других
    _drawAtom(canvas, Offset(centerX, centerY), unitSize * 0.5,
        const Color(0xFF66BB6A), 'Mg');

    // Остальные атомы меньшего размера
    for (final position in nodePositions) {
      _drawAtom(canvas, position, unitSize * 0.25, const Color(0xFF26A69A), '');
    }
  }

  void _drawAtom(
      Canvas canvas, Offset center, double radius, Color color, String symbol) {
    // Градиент для 3D эффекта
    final gradient = RadialGradient(
      colors: [
        color.withOpacity(0.8),
        color,
        color.withOpacity(0.5),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final paint = Paint()..style = PaintingStyle.fill;

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawCircle(center, radius, paint);

    // Блик для 3D эффекта
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.3,
      highlightPaint,
    );

    // Текст символа для главного атома
    if (symbol.isNotEmpty) {
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: radius * 1.2,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: symbol,
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

// Цинк стеарат - показываем молекулярную структуру с ионом цинка
class ZincStearateModelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.12;

    // Рисуем цепочку атомов (углеводородная цепь)
    final chainPaint = Paint()
      ..color = const Color(0xFF5C6BC0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Основная цепь
    final chainPath = Path();
    chainPath.moveTo(centerX - radius * 4, centerY - radius * 2);
    chainPath.lineTo(centerX - radius * 3, centerY - radius);
    chainPath.lineTo(centerX - radius * 2, centerY - radius * 2);
    chainPath.lineTo(centerX - radius, centerY - radius);
    chainPath.lineTo(centerX, centerY - radius * 2);
    chainPath.lineTo(centerX + radius, centerY - radius);
    chainPath.lineTo(centerX + radius * 2, centerY - radius * 2);
    chainPath.lineTo(centerX + radius * 3, centerY - radius);
    chainPath.lineTo(centerX + radius * 4, centerY - radius * 2);

    canvas.drawPath(chainPath, chainPaint);

    // Вторая цепь
    final chain2Path = Path();
    chain2Path.moveTo(centerX - radius * 4, centerY + radius * 2);
    chain2Path.lineTo(centerX - radius * 3, centerY + radius);
    chain2Path.lineTo(centerX - radius * 2, centerY + radius * 2);
    chain2Path.lineTo(centerX - radius, centerY + radius);
    chain2Path.lineTo(centerX, centerY + radius * 2);
    chain2Path.lineTo(centerX + radius, centerY + radius);
    chain2Path.lineTo(centerX + radius * 2, centerY + radius * 2);
    chain2Path.lineTo(centerX + radius * 3, centerY + radius);
    chain2Path.lineTo(centerX + radius * 4, centerY + radius * 2);

    canvas.drawPath(chain2Path, chainPaint);

    // Соединение цепей с центральным атомом
    canvas.drawLine(
      Offset(centerX, centerY - radius * 2),
      Offset(centerX, centerY - radius * 0.8),
      chainPaint,
    );

    canvas.drawLine(
      Offset(centerX, centerY + radius * 2),
      Offset(centerX, centerY + radius * 0.8),
      chainPaint,
    );

    // Рисуем атомы углерода в цепи
    final carbonPositions = [
      Offset(centerX - radius * 4, centerY - radius * 2),
      Offset(centerX - radius * 3, centerY - radius),
      Offset(centerX - radius * 2, centerY - radius * 2),
      Offset(centerX - radius, centerY - radius),
      Offset(centerX, centerY - radius * 2),
      Offset(centerX + radius, centerY - radius),
      Offset(centerX + radius * 2, centerY - radius * 2),
      Offset(centerX + radius * 3, centerY - radius),
      Offset(centerX + radius * 4, centerY - radius * 2),
      Offset(centerX - radius * 4, centerY + radius * 2),
      Offset(centerX - radius * 3, centerY + radius),
      Offset(centerX - radius * 2, centerY + radius * 2),
      Offset(centerX - radius, centerY + radius),
      Offset(centerX, centerY + radius * 2),
      Offset(centerX + radius, centerY + radius),
      Offset(centerX + radius * 2, centerY + radius * 2),
      Offset(centerX + radius * 3, centerY + radius),
      Offset(centerX + radius * 4, centerY + radius * 2),
    ];

    for (final position in carbonPositions) {
      _drawAtom(canvas, position, radius * 0.3, const Color(0xFF64B5F6));
    }

    // Рисуем ион цинка в центре (больше по размеру)
    _drawAtom(canvas, Offset(centerX, centerY), radius * 1.0,
        const Color(0xFF7E57C2), 'Zn');
  }

  void _drawAtom(Canvas canvas, Offset center, double radius, Color color,
      [String? symbol]) {
    // Градиент для 3D эффекта
    final gradient = RadialGradient(
      colors: [
        color.withOpacity(0.8),
        color,
        Colors.black.withOpacity(0.5),
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
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.3,
      highlightPaint,
    );

    // Текст символа элемента если передан
    if (symbol != null) {
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: radius * 1.2,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: symbol,
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

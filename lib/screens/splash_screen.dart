import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/repaint_boundary_container.dart';
import '../widgets/animated_text.dart';
import '../widgets/logo_widget.dart';
import '../configs/app_config.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final int _numElements = 80;
  late AnimationController _controller;
  List<ChemicalElementData> _elements = [];
  late Animation<double> _logoScaleAnimation;

  // Список химических элементов и формул
  final List<String> _chemicalSymbols = [
    'Ca',
    'Mg',
    'Zn',
    'H₂O',
    'CO₂',
    'O₂',
    'H₂',
    'C₂H₅OH',
    'CH₄',
    'C'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Отложенная инициализация химических элементов после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initElements();
      }
    });

    // Навигация на главный экран через 7 секунд
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  void _initElements() {
    final random = Random();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _elements = List.generate(_numElements, (index) {
      final size = random.nextDouble() * 40 + 20;
      final symbol = _chemicalSymbols[random.nextInt(_chemicalSymbols.length)];

      // Выбираем более темные оттенки разных цветов
      final colorShades = [
        const Color(0xFF1A237E).withOpacity(0.8), // темно-синий
        const Color(0xFF311B92).withOpacity(0.8), // темно-фиолетовый
        const Color(0xFF880E4F).withOpacity(0.7), // темно-розовый
        const Color(0xFF3E2723).withOpacity(0.8), // темно-коричневый
        const Color(0xFF004D40).withOpacity(0.8), // темно-зеленый
        const Color(0xFF01579B).withOpacity(0.7), // темно-голубой
        const Color(0xFF4A148C).withOpacity(0.8), // темно-пурпурный
        const Color(0xFF33691E).withOpacity(0.7), // темно-лаймовый
        const Color(0xFF263238).withOpacity(0.8), // сине-серый
        const Color(0xFF5D4037).withOpacity(0.7), // темно-коралловый
      ];

      return ChemicalElementData(
        position: Offset(
          random.nextDouble() * screenWidth,
          random.nextDouble() * screenHeight,
        ),
        color: colorShades[random.nextInt(colorShades.length)],
        size: size,
        speed: random.nextDouble() * 2 + 0.5,
        symbol: symbol,
        rotation: random.nextDouble() * 360,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppConfig.appThemeColor;
    final screenWidth = MediaQuery.of(context).size.width;

    return RepaintBoundaryContainer(
      repaintBoundaryKey: _repaintBoundaryKey,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                // Фоновый градиент
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConfig.appThemeColor.withOpacity(0.95),
                        AppConfig.appThemeColor.withOpacity(0.9),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Декоративный элемент - верхняя диагональная полоса
                Positioned(
                  top: 0,
                  right: 0,
                  child: RepaintBoundaryWrapper(
                    child: SizedBox(
                      width: screenWidth,
                      height: 200,
                      child: CustomPaint(
                        painter: SlashPainter(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ),
                ),

                // Декоративный элемент - нижняя диагональная полоса
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: RepaintBoundaryWrapper(
                    child: SizedBox(
                      width: screenWidth,
                      height: 200,
                      child: CustomPaint(
                        painter: BottomSlashPainter(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),

                // Анимированные химические элементы
                ...List.generate(_elements.length, (index) {
                  final element = _elements[index];
                  final offset = Offset(
                    element.position.dx,
                    element.position.dy -
                        (element.speed * _controller.value * 100),
                  );
                  final rotationAngle = element.rotation +
                      (_controller.value * 360 * (index % 2 == 0 ? 1 : -1));

                  // Добавляем пульсирующее изменение прозрачности
                  final opacityValue = 0.3 +
                      0.7 *
                          ((sin((_controller.value * 2 * pi) + (index * 0.2))) *
                                  0.5 +
                              0.5);

                  // Зацикливаем элементы
                  if (offset.dy < -element.size) {
                    _elements[index] = ChemicalElementData(
                      position: Offset(
                        element.position.dx,
                        MediaQuery.of(context).size.height + element.size,
                      ),
                      color: element.color,
                      size: element.size,
                      speed: element.speed,
                      symbol: element.symbol,
                      rotation: element.rotation,
                    );
                  }

                  return Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    child: RepaintBoundaryWrapper(
                      child: Transform.rotate(
                        angle: rotationAngle * pi / 180,
                        child: Container(
                          width: element.size,
                          height: element.size,
                          decoration: BoxDecoration(
                            color: element.color.withOpacity(opacityValue),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors.white.withOpacity(opacityValue * 0.8),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: element.color
                                    .withOpacity(opacityValue * 0.5),
                                blurRadius: 10,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              element.symbol,
                              style: TextStyle(
                                color: Colors.white.withOpacity(opacityValue),
                                fontWeight: FontWeight.bold,
                                fontSize: element.size * 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // Логотип и название компании
                Center(
                  child: RepaintBoundaryWrapper(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Логотип с анимацией появления
                        ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: const LogoWidget(
                            size: 150,
                            showShadow: true,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Название компании - анимированный текст
                        AnimatedText(
                          text: 'ООО «Химресурс»',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          delay: const Duration(milliseconds: 400),
                        ),
                        const SizedBox(height: 16),

                        // Разделительная линия с анимацией
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 800),
                          width: 250 * _controller.value,
                          height: 2,
                          color: Colors.white,
                          curve: Curves.easeInOut,
                        ),
                        const SizedBox(height: 16),

                        // Подзаголовок - анимированный текст
                        AnimatedText(
                          text: 'Качественные стеараты металлов',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          delay: const Duration(milliseconds: 800),
                          duration: const Duration(milliseconds: 600),
                        ),
                        const SizedBox(height: 50),

                        // Индикатор загрузки
                        RepaintBoundaryWrapper(
                          child: CircularProgressIndicator(
                            color: AppConfig.appThemeColor,
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Класс для хранения данных о химических элементах
class ChemicalElementData {
  final Offset position;
  final Color color;
  final double size;
  final double speed;
  final String symbol;
  final double rotation;

  ChemicalElementData({
    required this.position,
    required this.color,
    required this.size,
    required this.speed,
    required this.symbol,
    required this.rotation,
  });
}

// Класс для отрисовки верхней диагональной полосы
class SlashPainter extends CustomPainter {
  final Color color;

  SlashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.6, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Класс для отрисовки нижней диагональной полосы
class BottomSlashPainter extends CustomPainter {
  final Color color;

  BottomSlashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.4, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

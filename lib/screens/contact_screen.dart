import 'package:flutter/material.dart';
import '../widgets/repaint_boundary_container.dart';
import '../data/company_data.dart';
import '../configs/app_config.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Контроллеры для полей формы
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundaryContainer(
      repaintBoundaryKey: _repaintBoundaryKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: RepaintBoundaryWrapper(
            child: AppBar(
              title: const Text('Контакты'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Карта (статическое изображение)
              const Text(
                'Мы на карте',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RepaintBoundaryWrapper(
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        // Фон карты
                        Container(
                          color: const Color(0xFFF5F5F5),
                          width: double.infinity,
                          height: double.infinity,
                          child: CustomPaint(
                            painter: MapBackgroundPainter(),
                            size: Size.infinite,
                          ),
                        ),
                        // Сетка карты
                        CustomPaint(
                          painter: MapGridPainter(),
                          size: Size.infinite,
                        ),
                        // Центральный маркер
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppConfig.appThemeColor,
                                size: 48,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConfig.appThemeColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Химресурс',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Кнопка открытия карты
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showSnackBar(context,
                                  'Открытие карты не реализовано в демо-версии');
                            },
                            icon: const Icon(Icons.map),
                            label: const Text('Открыть карту'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConfig.appThemeColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Контактная информация
              const Text(
                'Контактная информация',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildContactItem(
                        icon: Icons.location_on,
                        title: 'Адрес:',
                        content: CompanyData.address,
                        onTap: () {
                          _showSnackBar(context,
                              'Открытие карты не реализовано в демо-версии');
                        },
                      ),
                      const Divider(),
                      _buildContactItem(
                        icon: Icons.phone,
                        title: 'Телефон:',
                        content: CompanyData.phone,
                        onTap: () {
                          _showSnackBar(
                              context, 'Звонок не реализован в демо-версии');
                        },
                      ),
                      const Divider(),
                      _buildContactItem(
                        icon: Icons.email,
                        title: 'Email:',
                        content: CompanyData.email,
                        onTap: () {
                          _showSnackBar(context,
                              'Отправка email не реализована в демо-версии');
                        },
                      ),
                      const Divider(),
                      _buildContactItem(
                        icon: Icons.access_time,
                        title: 'Режим работы:',
                        content: CompanyData.workHours,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Форма обратной связи
              const Text(
                'Напишите нам',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Ваше имя *',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите ваше имя';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите ваш email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Пожалуйста, введите корректный email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            labelText: 'Сообщение *',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите ваше сообщение';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Отправить',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Подписка на новости
              const Text(
                'Подписка на новости',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ваш Email',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _showSnackBar(
                              context, 'Функция подписки временно недоступна');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(content),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Тут будет отправка формы (например, через HTTP)
      // В демо-версии просто покажем сообщение
      _showSnackBar(context, 'Сообщение успешно отправлено!',
          color: Colors.green);

      // Очистка полей
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {Color color = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}

// В конце файла добавляем класс для рисования сетки карты
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Рисуем горизонтальные линии
    double y = 0;
    final horizontalSpacing = size.height / 12;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += horizontalSpacing;
    }

    // Рисуем вертикальные линии
    double x = 0;
    final verticalSpacing = size.width / 12;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      x += verticalSpacing;
    }

    // Рисуем окружности для дорог
    final circlePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.15,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.8),
      size.width * 0.2,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Добавляем класс для рисования фона карты
class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Основной цвет фона
    final backgroundPaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Рисуем дороги
    final roadPaint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..style = PaintingStyle.fill;

    // Горизонтальная главная дорога
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5 - 15, size.width, 30),
      roadPaint,
    );

    // Вертикальная главная дорога
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5 - 15, 0, 30, size.height),
      roadPaint,
    );

    // Рисуем блоки (кварталы)
    final blockPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.fill;

    // Верхний левый блок
    canvas.drawRect(
      Rect.fromLTWH(20, 20, size.width * 0.4, size.height * 0.4),
      blockPaint,
    );

    // Верхний правый блок
    canvas.drawRect(
      Rect.fromLTWH(
          size.width * 0.6, 20, size.width * 0.4 - 20, size.height * 0.4),
      blockPaint,
    );

    // Нижний левый блок
    canvas.drawRect(
      Rect.fromLTWH(
          20, size.height * 0.6, size.width * 0.4, size.height * 0.4 - 20),
      blockPaint,
    );

    // Нижний правый блок (наша локация)
    final ourLocationPaint = Paint()
      ..color = AppConfig.appThemeColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.6, size.width * 0.4 - 20,
          size.height * 0.4 - 20),
      ourLocationPaint,
    );

    // Водоем (парк или озеро)
    final waterPaint = Paint()
      ..color = const Color(0xFFB3E5FC)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.25),
      size.width * 0.1,
      waterPaint,
    );

    // Рисуем мелкие дороги
    final smallRoadPaint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Несколько мелких дорог в левой верхней части
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.4, size.height * 0.1),
      smallRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.4, size.height * 0.2),
      smallRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.4),
      smallRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.4),
      smallRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

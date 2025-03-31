import 'package:flutter/material.dart';
import '../widgets/repaint_boundary_container.dart';
import '../data/company_data.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
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
              title: const Text('Доставка'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              const Center(
                child: Text(
                  'Информация о доставке',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Основная информация о доставке
              Text(
                CompanyData.deliveryInfo,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 24),

              // Преимущества доставки
              const Text(
                'Преимущества работы с нами',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildAdvantageCard(
                icon: Icons.speed,
                title: 'Оперативность',
                description:
                    'Мы стремимся доставить заказанную продукцию в кратчайшие сроки.',
              ),

              _buildAdvantageCard(
                icon: Icons.security,
                title: 'Надежность',
                description:
                    'Мы работаем только с проверенными транспортными компаниями, что гарантирует сохранность вашего груза.',
              ),

              _buildAdvantageCard(
                icon: Icons.location_on,
                title: 'Широкая география доставки',
                description:
                    'Мы осуществляем доставку по всей России и странам СНГ.',
              ),

              _buildAdvantageCard(
                icon: Icons.attach_money,
                title: 'Гибкие условия оплаты',
                description:
                    'Возможность выбора оптимального способа оплаты для вашей компании.',
              ),

              const SizedBox(height: 24),

              // Условия доставки
              const Text(
                'Условия доставки',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildConditionItem(
                        title: 'Минимальный объем заказа',
                        content: 'От 1 тонны продукции.',
                      ),
                      _buildConditionItem(
                        title: 'Сроки доставки',
                        content:
                            'От 1 до 7 рабочих дней в зависимости от региона доставки.',
                      ),
                      _buildConditionItem(
                        title: 'Стоимость доставки',
                        content:
                            'Рассчитывается индивидуально в зависимости от объема заказа и региона доставки.',
                      ),
                      _buildConditionItem(
                        title: 'Документы',
                        content:
                            'Полный пакет сопроводительных документов предоставляется вместе с заказом.',
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Контактная информация для заказа доставки
              const Text(
                'Заказать доставку',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Для заказа доставки свяжитесь с нами:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.phone,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            CompanyData.phone,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            CompanyData.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/contact');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Связаться с нами',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Дополнительная информация
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Для получения более подробной информации о доставке, пожалуйста, свяжитесь с нами',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvantageCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem({
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        if (!isLast) const Divider(height: 24),
      ],
    );
  }
}

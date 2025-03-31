import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/repaint_boundary_container.dart';
import '../data/company_data.dart';
import '../configs/app_config.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
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
              title: const Text('О компании'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхнее изображение с заголовком
              RepaintBoundaryWrapper(
                child: Stack(
                  children: [
                    Image.asset(
                      AppConfig.companyImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          child: const Center(
                            child: Icon(
                              Icons.business,
                              size: 80,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: RepaintBoundaryWrapper(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'О компании',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ООО НПО «Химресурс» с 2012 года',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // История компании
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('История компании'),
                    ),
                    const SizedBox(height: 12),
                    RepaintBoundaryWrapper(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              CompanyData.history,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Фото лаборатории
                    RepaintBoundaryWrapper(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppConfig.labImage,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              child: const Center(
                                child: Icon(
                                  Icons.science,
                                  size: 80,
                                  color: Colors.white70,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Подробное описание
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('О нас'),
                    ),
                    const SizedBox(height: 12),
                    RepaintBoundaryWrapper(
                      child: Text(
                        CompanyData.description,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Преимущества компании
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('Наши преимущества'),
                    ),
                    const SizedBox(height: 16),
                    RepaintBoundaryWrapper(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: CompanyData.advantages
                              .map((advantage) => RepaintBoundaryWrapper(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Colors.green),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              advantage,
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

                    const SizedBox(height: 24),

                    // Блок с контактной информацией
                    RepaintBoundaryWrapper(
                      child: _buildSectionTitle('Контактная информация'),
                    ),
                    const SizedBox(height: 16),
                    RepaintBoundaryWrapper(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              RepaintBoundaryWrapper(
                                child: _buildContactRow(
                                  icon: Icons.location_on,
                                  title: 'Адрес:',
                                  content: CompanyData.address,
                                ),
                              ),
                              const Divider(),
                              RepaintBoundaryWrapper(
                                child: _buildContactRow(
                                  icon: Icons.phone,
                                  title: 'Телефон:',
                                  content: CompanyData.phone,
                                ),
                              ),
                              const Divider(),
                              RepaintBoundaryWrapper(
                                child: _buildContactRow(
                                  icon: Icons.email,
                                  title: 'Email:',
                                  content: CompanyData.email,
                                ),
                              ),
                              const Divider(),
                              RepaintBoundaryWrapper(
                                child: _buildContactRow(
                                  icon: Icons.access_time,
                                  title: 'Режим работы:',
                                  content: CompanyData.workHours,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Кнопка связаться
                    Center(
                      child: RepaintBoundaryWrapper(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone),
                          label: const Text('Связаться с нами'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/contact');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

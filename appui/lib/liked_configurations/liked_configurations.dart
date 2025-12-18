// Страница отображения понравившихся сборок пользователя.
// Использует LikedProvider для управления состоянием избранных конфигураций.

import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/configuration_page/Configuration_Details_Page.dart';
import 'package:appui/configuration_page/configuration_choose_page.dart';
import 'package:appui/main_page/main_page.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/providers/liked_provider.dart';
import 'package:appui/user_profile/user_profile.dart';
import 'package:appui/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LikedConfigurations extends StatelessWidget {
  const LikedConfigurations({super.key});

  @override
  Widget build(BuildContext context) {
    // виджет понравившихся конфигураций
    final likedProvider = Provider.of<LikedProvider>(context);
    final likedConfigs = likedProvider.likedConfigs;  // Список ID понравившихся сборок

    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
      body: Column(
        children: [
          _buildHeader(context), // билдим заголовок
          Expanded(
            child: likedConfigs.isEmpty // проверка списка понравившихся сборок
              ? const Center(
                    child: Text(
                      'Нет понравившихся сборок',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    // если список не пустой, то показываем конфигурации
                    padding: const EdgeInsets.all(20),
                    itemCount: likedConfigs.length,
                    itemBuilder: (context, index) {
                      final configId = likedConfigs[index];
                      return _buildFavoriteItem(
                        // при нажатии на сборку переходим на страницу с деталями
                        configId: configId,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfigurationDetailsPage(
                                selectedOption: configId,  // Переход к деталям сборки
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Строит элемент списка избранных сборок
  Widget _buildFavoriteItem({
    required int configId,
    required VoidCallback onTap,
  }) {
    final title = 'Вариант $configId';  // Формирование названия

    return Card(
      color: const Color.fromRGBO(30, 10, 50, 0.9),
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,  // Обработчик нажатия
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Строит верхнюю панель навигации
  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 59, horizontal: 100),
      child: Row(
        children: [
          // Логотип
          InkWell(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            ),
            child: const GradientText(
              'SanyaPC',
              style: TextStyle(fontSize: 40),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(4, 101, 188, 1),
                Color.fromRGBO(166, 247, 135, 1),
              ]),
            ),
          ),
          const Spacer(),
          // Кнопка конфигуратора
          InkWell(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ConfigurationChoosePage(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Конфигуратор',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 33),
          // Кнопка избранного (текущая страница)
          InkWell(
            onTap: () {
              // Переход к понравившимся сборкам
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Понравившиеся сборки',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 33),
          // Кнопка профиля
          InkWell(
            onTap: () {
              if (authProvider.authorized) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfile()),
                );
              } else {
                // Показ окна входа
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: authProvider.authorized
                  ? SvgPicture.asset(
                      AppIcons.ProfileAuthorized,
                      height: 86,
                      width: 87,
                    )
                  : SvgPicture.asset(
                      AppIcons.ProfileNoAuthorized,
                      height: 86,
                      width: 87,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

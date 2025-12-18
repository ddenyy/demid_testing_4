// Страница выбора параметров для конфигурации ПК.
// Позволяет пользователю задать бюджет и выбрать назначение компьютера. 
// (Не работает. У нас сборка одна и она статичная. Не успели сделать)
// 
//  функции:
//  Установка максимального бюджета
//  Выбор цели использования ПК (игры, работа, офис)
//  Навигация между разделами приложения
//  Обработка авторизации пользователя

import 'dart:ui';
import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/configuration_page/configuration_page.dart';
import 'package:appui/liked_configurations/liked_configurations.dart';
import 'package:appui/main_page/main_page.dart';
import 'package:appui/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/values/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfigurationChoosePage extends StatefulWidget {
  const ConfigurationChoosePage({super.key});

  @override
  State<ConfigurationChoosePage> createState() =>
      _ConfigurationChoosePageState();
}

class _ConfigurationChoosePageState extends State<ConfigurationChoosePage> {
  int maxPrice = 150000; // Максимальная цена по умолчанию
  String selectedPurpose = 'Игры';// назначение ПК по умолчанию
  bool showLoginWindow = false;// Флаг показа окна авторизации

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 59, horizontal: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),        // Верхняя панель навигации
                const SizedBox(height: 100),
                _buildMainContent(authProvider),  // Основной контент страницы
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Строит верхнюю панель навигации приложения
  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Row(
      children: [
        // Логотип приложения с градиентным текстом
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
        // Кнопка перехода в конфигуратор (текущая страница)
        InkWell(
          onTap: () {}, // Уже на странице конфигуратора
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Конфигуратор',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(width: 33),
        // Кнопка перехода к понравившимся сборкам
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LikedConfigurations(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Понравившиеся сборки',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(width: 33),
        // Кнопка профиля пользователя
        InkWell(
          onTap: () {
            if (authProvider.authorized) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            } else {
              setState(() {
                showLoginWindow = true;  // Показать окно входа если не авторизован
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: authProvider.authorized
                ? SvgPicture.asset(  // Иконка авторизованного пользователя
                    AppIcons.ProfileAuthorized,
                    height: 86,
                    width: 87,
                  )
                : SvgPicture.asset(  // Иконка неавторизованного пользователя
                    AppIcons.ProfileNoAuthorized,
                    height: 86,
                    width: 87,
                  ),
          ),
        ),
      ],
    );
  }

  // Строит основной контент страницы выбора параметров
  Widget _buildMainContent(AuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Панель выбора максимальной цены
          Container(
            width: 600,
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(),  // Стиль панели
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Введите максимальную цену сборки',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: '150000',  // Значение по умолчанию
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('₽'),
                  onChanged: (value) {
                    setState(() {
                      maxPrice = int.tryParse(value) ?? 150000;  // Обновление цены
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Панель выбора назначения сборки (не работает)
          Container(
            width: 600,
            padding: const EdgeInsets.all(20),
            decoration: _panelDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Введите назначение сборки',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    _buildPurposeRadio(
                      'Игры',
                    ),
                    _buildPurposeRadio(
                      'Работа (программирование и монтаж)',
                    ),
                    _buildPurposeRadio(
                      'Офисные задачи',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Кнопка перехода к следующему шагу
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(15, 174, 150, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                _proceedToNextStep();  // вызываем функцию для перехода на страницу конфигуррции
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Далее',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // обрабатывает переход к следующему шагу процесса сборки 
  void _proceedToNextStep() {
    print('Переход к следующему шагу с параметрами:');
    print('Максимальная цена: $maxPrice');
    print('Назначение: $selectedPurpose');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfigurationPage()),  // Переход на страницу конфигурации
    );
  }

  // создает оформление для панелей
  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: const Color.fromRGBO(30, 10, 50, 0.9),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Colors.white.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  // создает оформление для полей ввода
  InputDecoration _inputDecoration(String suffix) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: Colors.white),
    );
  }

  // Строит кнопку для выбора назначения ПК 
  Widget _buildPurposeRadio(String value) {
    //билдер кнопки выбора
    return RadioListTile<String>(
      title: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      groupValue: selectedPurpose,
      activeColor: const Color.fromRGBO(15, 174, 150, 1),
      onChanged: (String? newValue) {
        setState(() {
          selectedPurpose = newValue!;  // Обновление выбранного значения
        });
      },
    );
  }
}

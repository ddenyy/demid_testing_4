// Страница выбора конкретной конфигурации ПК.
// Отображает список доступных вариантов сборок и их характеристики (сборка всего 1).
// Интегрируется с сервером для получения актуальных данных о компонентах.
// 
// Основные функции:
// - Отображение вариантов сборок
// - Показ характеристик выбранной конфигурации
// - Добавление сборок в избранное
// - Переход к детальной информации

import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/configuration_page/Configuration_Details_Page.dart';
import 'package:appui/configuration_page/configuration_choose_page.dart';
import 'package:appui/liked_configurations/liked_configurations.dart';
import 'package:appui/main_page/main_page.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/providers/liked_provider.dart';
import 'package:appui/src/src/build_service_client.dart';
import 'package:appui/src/src/generated/assembly.pb.dart';
import 'package:appui/user_profile/user_profile.dart';
import 'package:appui/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final buildClient = BuildServiceClientWrapper();  // Клиент для работы с API сборок
  int selectedOption = 1;                           // ID выбранной опции
  // Данные о вариантах сборок
  final Map<int, Map<String, dynamic>>  options = {
    
    
    1: {
    'title': 'Вариант 4',
    'specs': {},    // Характеристики компонентов
    'price': '',    // Цена сборки
  },
  };
@override
void initState() {
  super.initState();
    _getBuild();  // Загрузка данных при инициализации
  
}
// Загружает данные о сборке с сервера
Future<void> _getBuild() async {
  try {
    final build = await buildClient.getOneBuild();  // получение сборки с сервера

      // Вспомогательная функция для поиска компонента по ключевому слову
    Component? tryFindComponent(List<Component> components, String keyword) {
      try {
        return components.firstWhere(
          (c) => c.type.toLowerCase().contains(keyword),  // Поиск по типу компонента
        );
      } catch (_) {
        return null;  // Возврат null если компонент не найден
      }
    }

    // Поиск основных компонентов в сборке
    final cpu = tryFindComponent(build.components, 'cpu');
    final gpu = tryFindComponent(build.components, 'gpu');
    final ram = tryFindComponent(build.components, 'ram');

    // Формирование списка характеристик
    final specs = <String, String>{
      if (gpu != null) 'Видеокарта': '${gpu.name} (${gpu.manufacturer})',
      if (cpu != null) 'Процессор': '${cpu.name} (${cpu.manufacturer})',
      if (ram != null) 'Оперативная память': '${ram.name} (${ram.manufacturer})',
    };

    setState(() {
      options[1] = {
        'title': 'Вариант 4',
        'specs': specs,
        'price': '120\'000р',
      };
      selectedOption = 1;
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка: $e')),  // Показ ошибки
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),

      body: Column(
        children: [
          _buildHeader(context),  // Верхняя панель навигации
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOptionsPanel(),  // Левая панель с вариантами
                  const SizedBox(width: 40),
                  _buildSpecsPanel(),    // Правая панель с характеристиками
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Строит левую панель с вариантами сборок
  Widget _buildOptionsPanel() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 10, 50, 0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите вариант сборки',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...options.keys.map((option) => _buildOptionItem(option)).toList(),  // Список вариантов
          ],
        ),
      ),
    );
  }

  // Строит элемент списка вариантов сборки
  Widget _buildOptionItem(int option) {
    final likedProvider = Provider.of<LikedProvider>(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: selectedOption == option  // Подсветка выбранного варианта
            ? const Color.fromRGBO(15, 174, 150, 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => setState(() => selectedOption = option),  // Выбор варианта
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedOption == option // цвет границы
                    ? const Color.fromRGBO(15, 174, 150, 1)
                    : Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  // кнопка добавления в понравившиеся сборки
                  icon: SvgPicture.asset(
                    likedProvider.isLiked(option)  // Проверка статуса лайка
                        ? AppIcons.StarFilled
                        : AppIcons.StarOutline,
                    height: 39,
                    width: 39,
                  ),
                  onPressed: () => likedProvider.toggleLike(option),  // Переключение статуса
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    options[option]!['title'],  // Название варианта
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: selectedOption == option
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Строит правую панель с характеристиками выбранной сборки
  Widget _buildSpecsPanel() {
    final currentOption = options[selectedOption]!;  // Данные выбранной опции

    return Expanded(
      flex: 3,
      child: Container(
        height: 602,
        width: 616,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 10, 50, 0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentOption['title'],  // Заголовок сборки
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Список характеристик компонентов
            ...currentOption['specs']
                .entries
                .map((entry) => _buildSpecItem(entry.key, entry.value))
                .toList(),
            const Spacer(),
            // Отображение цены
            Text(
              'Стоимость ${currentOption['price']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                //кнопочка перехода на страницу с более детальным описанием
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(15, 174, 150, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigurationDetailsPage(
                        selectedOption: selectedOption,  // Передача выбранного варианта для перехода на страницу с деталями
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Подробнее',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //билдер текста компонентов
  Widget _buildSpecItem(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            //иконочка чипа слева
            AppIcons.ChipIcon,
            height: 48,
            width: 48,
          ),
          const SizedBox(
            width: 15,
            height: 90,
          ),
          Expanded(
            child: Text(
              //пишем вид компонента и его название с краткими характеристиками
              '$name: $value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ],
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
          // Логотип приложения
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
          // Кнопка избранных сборок
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

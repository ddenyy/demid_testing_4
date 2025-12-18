// Страница детального просмотра конфигурации ПК. 
// Отображает полную информацию о компонентах выбранной сборки.
// Интегрируется с сервером для загрузки актуальных данных.

import 'package:appui/configuration_page/configuration_choose_page.dart';
import 'package:appui/liked_configurations/liked_configurations.dart';
import 'package:appui/src/src/build_service_client.dart';
import 'package:flutter/material.dart';
import 'package:appui/values/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/main_page/main_page.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/user_profile/user_profile.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class ConfigurationDetailsPage extends StatefulWidget {
  final int selectedOption; // id выбранной сборки
  final List<Map<String, String>>? customComponents;  // Кастомные компоненты
  final String? customTotalPrice; // кастомная цена

  const ConfigurationDetailsPage({
    super.key,
    required this.selectedOption,
    this.customComponents,
    this.customTotalPrice,
  });

  @override
  State<ConfigurationDetailsPage> createState() =>
      _ConfigurationDetailsPageState();
}

class _ConfigurationDetailsPageState extends State<ConfigurationDetailsPage> {
  final buildClient = BuildServiceClientWrapper();  // Клиент для API сборок
  bool isLoading = false;  // Флаг загрузки
  bool showStoreSelection = false; // Флаг показа выбора магазина
  
  // Детальная информация о сборке (это то что было изначально. Просто заглушка. Сейчас у нас получаются данные из базы, правда сборка всего 1)
  final Map<int, Map<String, dynamic>> configDetails = {
    1: {
      'title': 'Вариант 1 ',
      'totalPrice': '180\'000р',
      'components': [
        {'name': 'Видеокарта', 'desc': 'NVidia RTX 5090 24GB GDDR7'},
        {'name': 'Процессор', 'desc': 'Intel Core i9-14900KF 24 ядра'},
        {
          'name': 'Оперативная память',
          'desc': '32 ГБ 6000 MHz DDR5 G.Skill TRIDENT Z5 RGB'
        },
        {'name': 'SSD накопитель', 'desc': '2TB IT5 M.2 NVMe Samsung 990 PRO'},
        {'name': 'Материнская плата', 'desc': 'MSI Z790 GAMING PLUS'},
        {'name': 'Блок питания', 'desc': 'Aerocool Kcas 1000W 80+ Platinum'},
        {'name': 'Охлаждение', 'desc': 'Asus ROG RYUO III 360 ARGB'},
        {'name': 'Корпус', 'desc': 'Be Quiet! SILENT BASE 802 WINDOW Black'},
      ],
    },
    2: {
      'title': 'Вариант 2 ',
      'totalPrice': '160\'000р',
      'components': [
        {'name': 'Видеокарта', 'desc': 'AMD RX 8900 XT 32GB GDDR7'},
        {'name': 'Процессор', 'desc': 'Ryzen 9 7950X3D 16 ядер'},
        {
          'name': 'Оперативная память',
          'desc': '64 ГБ 6400 MHz DDR5 Kingston Fury Renegade'
        },
        {'name': 'SSD накопитель', 'desc': '4TB IT5 M.2 NVMe WD Black SN850X'},
        {'name': 'Материнская плата', 'desc': 'ASUS ROG Crosshair X670E Hero'},
        {
          'name': 'Блок питания',
          'desc': 'Seasonic PRIME TX-1000 1000W 80+ Titanium'
        },
        {'name': 'Охлаждение', 'desc': 'NZXT Kraken Z73 RGB 360mm'},
        {'name': 'Корпус', 'desc': 'Lian Li PC-O11 Dynamic XL ROG'},
      ],
    },
    3: {
      'title': 'Вариант 3',
      'totalPrice': '140\'000',
      'components': [
        {'name': 'Видеокарта', 'desc': 'NVidia RTX 4080 Super 16GB GDDR6X'},
        {'name': 'Процессор', 'desc': 'Intel i7-13700K 16 ядер'},
        {
          'name': 'Оперативная память',
          'desc': '16 ГБ 5600 MHz DDR5 Corsair Vengeance'
        },
        {'name': 'SSD накопитель', 'desc': '1TB IT5 M.2 NVMe Crucial P5 Plus'},
        {'name': 'Материнская плата', 'desc': 'Gigabyte Z790 UD AC'},
        {'name': 'Блок питания', 'desc': 'Corsair RM850x 850W 80+ Gold'},
        {'name': 'Охлаждение', 'desc': 'Deepcool AK620 Zero Dark'},
        {'name': 'Корпус', 'desc': 'Fractal Design Meshify C'},
      ],
    },
    4: { 
    'title': 'Вариант 4',
    'totalPrice': 'Загрузка...',
    'components': [],
  },
  };
  // Загружает данные сборки с сервера для варианта 4
Future<void> _fetchBuildFromServer() async {
  if (widget.selectedOption != 4) return;  // Только для варианта 4

  setState(() => isLoading = true);
  
  try {
    final build = await buildClient.getOneBuild();  // Получение данных

    // Преобразование компонентов в формат для отображения
    final components = build.components.map((component) {
      return {
        'name': component.type,
        'desc': '${component.name} (${component.manufacturer})',
      };
    }).toList();

    

    setState(() {
      configDetails[4] = {
        'title': 'Вариант 4',
        'totalPrice': '120\'000р',
        'components': components,
      };
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка загрузки: $e')),  // показ ошбки
    );
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

  // Показывает диалог выбора магазина
  void _showStoreDialog() {
    setState(() {
      showStoreSelection = true;
    });
  }

  // скрывает диалог выбора магазина
  void _hideStoreDialog() {
    setState(() {
      showStoreSelection = false;
    });
  }

  // билдер окна выбора магазина при нажатии на "купить"
  Widget _buildStoreSelectionDialog() {
    
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 10, 50, 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Выберите магазин',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30), //при нажатии на магазин скрываем окно
            _buildStoreButton('DNS', () {
              _hideStoreDialog();
              // Действие при выборе DNS
            }),
            const SizedBox(height: 15),
            _buildStoreButton('Эльдорадо', () {
              _hideStoreDialog();
              // Действие при выборе Эльдорадо
            }),
            const SizedBox(height: 15),
            _buildStoreButton('MVIDEO', () {
              _hideStoreDialog();
              // Действие при выборе MVIDEO
            }),
          ],
        ),
      ),
    );
  }
@override
void initState() {
  super.initState();
  if (widget.selectedOption == 4) {
    _fetchBuildFromServer(); //загрузка данных для четвертой сборки
  }
}
  Widget _buildStoreButton(String storeName, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(15, 174, 150, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(
        storeName,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final bool isCustom = widget.selectedOption == 4;  // Проверка кастомной сборки
  
  // Показ индикатора загрузки
  if (isLoading) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
      body: Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(15, 174, 150, 1),
        ),
      ),
    );
  }

    // Получение данных текущей конфигурации
  final currentConfig = isCustom
      ? configDetails[4] ?? {
          'title': 'Сборка с сервера',
          'totalPrice': 'Загрузка...',
          'components': [],
        }
      : configDetails[widget.selectedOption]!;

  return Scaffold(
    backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
    body: Stack(
      children: [
        Column(
          children: [
            _buildHeader(context),  // Верхняя панель
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок сборки
                    Text(
                      currentConfig['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Список компонентов
                    ...List<Widget>.from(
                      (currentConfig['components'] as List)
                          .map((component) => _buildComponentCard(
                                component['name']!,
                                component['desc']!,
                              )),
                    ),
                    const SizedBox(height: 40),
                    // Общая стоимость
                    Text(
                      'Общая стоимость: ${currentConfig['totalPrice']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Размытый фон для диалога
        if (showStoreSelection)
          GestureDetector(
            onTap: _hideStoreDialog,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        // Диалог выбора магазина
        if (showStoreSelection) _buildStoreSelectionDialog(),
      ],
    ),
  );
}

  //билдер карточек компонентов
  Widget _buildComponentCard(String name, String description) {
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 10, 50, 0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            //иконка слева микросхемы слева от компонетов
            AppIcons.ChipIcon,
            height: 48,
            width: 48,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              // текст компонентов
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            //кнопка купить
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(15, 174, 150, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 12,
              ),
            ),
            onPressed:
                _showStoreDialog, //поднимаем флаг showStoreSelection чтобы открыть окно с магазинами
            child: const Text(
              'Купить',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
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
          // Кнопка избранного
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

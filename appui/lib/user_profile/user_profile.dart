// Страница профиля пользователя с теоретической возможностью изменения данных. (данные не меняются)
// Позволяет изменить логин и пароль

import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/configuration_page/configuration_choose_page.dart';
import 'package:appui/liked_configurations/liked_configurations.dart';
import 'package:appui/main_page/main_page.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  bool showLoginWindow = false;
  bool authorized = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 59, horizontal: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),        // Верхняя панель
                const SizedBox(height: 37),
                _buildMainContent(),   // Основной контент профиля
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Строит основной контент страницы профиля
  Widget _buildMainContent() {
    final TextEditingController passwordController1 = TextEditingController();  // Текущий пароль
    final TextEditingController passwordController2 = TextEditingController();  // Новый пароль
    final TextEditingController passwordController3 = TextEditingController();  // Подтверждение пароля
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final TextEditingController loginController = TextEditingController();      // Новый логин
    final formKey = GlobalKey<FormState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(//заголовок
              "Профиль пользователя",
              style: TextStyle(
                  color: Color.fromRGBO(15, 174, 150, 1), fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(//текущий логин пользователя
              authProvider.User_Login,
              style: TextStyle(
                  color: Color.fromRGBO(15, 174, 150, 1), fontSize: 24),
            ),
            SizedBox(
              height: 151,
            ),
            Text(//новый логин пользователя
              "Новый логин",
              style: TextStyle(
                  fontSize: 16, color: Color.fromRGBO(56, 77, 108, 1)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              // Поле изменения логина
              width: 600,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(30, 10, 50, 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: loginController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'ex. Gretta Tuborg',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(171, 177, 187, 1)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          //изменение поля ввода при выборе
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите логин';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 42,
            ),
            //поле сменя пароля
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ввод текущего пароля
                Column(
                  children: [
                    Text(
                      "Текущий пароль",
                      style: TextStyle(
                          color: Color.fromRGBO(56, 77, 108, 1), fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(30, 10, 50, 0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: passwordController1,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите пароль';
                          }
                          if (value.length < 6) {
                            return 'Пароль должен быть не менее 6 символов';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 44),
                // Новый пароль
                Column(
                  //Ввод нового пароля
                  children: [
                    Text(
                      "Новый пароль",
                      style: TextStyle(
                          color: Color.fromRGBO(56, 77, 108, 1), fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(30, 10, 50, 0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: passwordController2,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите пароль';
                          }
                          if (value.length < 6) {
                            return 'Пароль должен быть не менее 6 символов';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              //подтверждение пароля
              children: [
                Text("Подтвердите пароль", style: TextStyle(color: Color.fromRGBO(56, 77, 108, 1), fontSize: 16)),
                SizedBox(height: 10),
                Container(
                  width: 1044,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(30, 10, 50, 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: TextFormField(
                    controller: passwordController3,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                ElevatedButton(
                  //Кнопка выхода из профиля. При нажатии authorized становится false, выкидывает на главную страницу
                  onPressed: () {
                    authProvider.authorized = false;
                    authProvider.User_Login = '';
                    authProvider.User_Password = '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: Text(
                    'Выход из профиля',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                // Кнопка сохранения
                ElevatedButton(
                  onPressed: () {
                    // TODO: добавить сохранение изменений в базу (так и не сделано)
                  },
                  child: Text(
                    'Сохранить изменения',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(15, 174, 150, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Строит верхнюю панель навигации
  Widget _buildHeader() {
    return Row(
      children: [
        // Логотип
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConfigurationChoosePage()),
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
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              AppIcons.ProfileAuthorized,
              height: 86,
              width: 87,
            ),
          ),
        ),
      ],
    );
  }
}

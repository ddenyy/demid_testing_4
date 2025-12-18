// Главная страница приложения с основным контентом и окнами авторизации/регистрации
// Содержит навигацию по приложению

import 'dart:ui';
import 'package:appui/GradientTextWidget/Gradient_Text.dart';
import 'package:appui/configuration_page/configuration_choose_page.dart';
import 'package:appui/liked_configurations/liked_configurations.dart';
import 'package:appui/providers/auth_provider.dart';
import 'package:appui/src/generated/auth_service_client.dart';
import 'package:appui/user_profile/user_profile.dart';
import 'package:appui/values/app_icons.dart';
import 'package:appui/values/app_imgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  bool showLoginWindow = false; // флаг показа окна входа
  bool showRegisterWindow = false; // флаг показа окна регистрации
  bool _isAuthorized = false; // флаг авторизации

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 1, 30, 1),
      body: Stack(
        children: [
          // Основной контент
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 59, horizontal: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),// Верхняя панель
                const SizedBox(height: 193),
                _buildMainContent(),   // Основной контент
              ],
            ),
          ),

          // Размытый фон для окон
          if (showLoginWindow || showRegisterWindow)
            GestureDetector(
              behavior: HitTestBehavior.opaque, //реагирует на нажатия вне окон
              onTap: () {
                setState(() {
                  showLoginWindow = false;
                  showRegisterWindow = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),  // эффект размытия
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),

          // окна входа и регистранции
          if (showLoginWindow)
            Center(
              child: GestureDetector(
                onTap: () {},
                child: _buildLoginWindow(),
              ),
            ),

          if (showRegisterWindow)
            Center(
              child: GestureDetector(
                onTap: () {},
                child: _buildRegisterWindow(),
              ),
            ),
        ],
      ),
    );
  }

  // Строит окно входа
  Widget _buildLoginWindow() {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final AuthServiceClientWrapper client = AuthServiceClientWrapper();
    final formKey = GlobalKey<FormState>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String message = '';
    bool isLoading = false;
    

    return StatefulBuilder(
      builder: (context, setState) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(30, 10, 50, 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: formKey, //ключ для валидности
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Вход',
                      style: TextStyle(
                        color: Color.fromRGBO(15, 174, 150, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Поле логина
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Логин',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.7)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите логин';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Поле пароля
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Пароль',
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.7)),
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
                  const SizedBox(height: 30),

                  // Отображение ошибок
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Индикатор загрузки
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    )
                  else
                    // Кнопка входа
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(15, 174, 150, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              message = '';
                            });

                            try {
                              final response = await client.login(//попытка логина
                                _usernameController.text,
                                _passwordController.text,
                              );

                              if (response.success) {//если успех
                                setState(() {
                                  authProvider.authorized = true;
                                  authProvider.User_Login =
                                      _usernameController.text;
                                  authProvider.User_Password =
                                      _passwordController.text;
                                
                                });
                                // Обновляем состояние родительского виджета
                                if (mounted) {
                                  setState(() {
                                    _isAuthorized = true;
                                    showLoginWindow = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  message = 'Login failed: ${response.message}';
                                });
                              }
                            } catch (e) {
                              setState(() {
                                message = 'Ошибка соединения с сервером';
                              });
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text('Войти',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Ссылка на регистрацию
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showLoginWindow = false;
                      });
                      if (mounted) {
                        this.setState(() {
                          showRegisterWindow = true;
                        });
                      }
                    },
                    child: const Text(
                      'Нет аккаунта? Зарегистрироваться',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Строит окно регистрации (аналогично окну входа)
  Widget _buildRegisterWindow() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final AuthServiceClientWrapper client = AuthServiceClientWrapper();
    final formKey = GlobalKey<FormState>();

    String message = '';
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(30, 10, 50, 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'Регистрация',
                      style: TextStyle(
                        color: Color.fromRGBO(15, 174, 150, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Поле логина
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: usernameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Логин',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.7)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите логин';
                        }
                        if (value.length < 4) {
                          return 'Логин должен быть не менее 4 символов';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Поле пароля
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Пароль',
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.7)),
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
                  const SizedBox(height: 20),

                  // Подтверждение пароля
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Подтвердите пароль',
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.7)),
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
                          return 'Подтвердите пароль';
                        }
                        if (value != passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Отображение ошибок
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Индикатор загрузки
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    )
                  else
                    // Кнопка регистрации
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(15, 174, 150, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              message = '';
                            });

                            try {
                              final response = await client.register(
                                usernameController.text,
                                passwordController.text,
                                confirmPasswordController.text,
                              );

                              if (response.success) {
                                setState(() {
                                  message =
                                      'Регистрация успешна! Войдите в систему';
                                });
                                // Обновляем состояние родительского виджета
                                if (mounted) {
                                  setState(() {
                                    showRegisterWindow = false;
                                    showLoginWindow = true;
                                  });
                                }
                              } else {
                                setState(() {
                                  message =
                                      'Ошибка регистрации: ${response.message}';
                                });
                              }
                            } catch (e) {
                              setState(() {
                                message = 'Ошибка соединения с сервером';
                              });
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Ссылка на вход
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showRegisterWindow = false;
                      });
                      if (mounted) {
                        this.setState(() {
                          showLoginWindow = true;
                        });
                      }
                    },
                    child: const Text(
                      'Уже есть аккаунт? Войти',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Row(
      children: [
        // Логотип
        InkWell(
          onTap: () => Navigator.push(
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
          onTap: () {
            if (authProvider.authorized) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigurationChoosePage()),
              );
            } else {
              setState(() {
                showLoginWindow = true;  // показать окно входа если не авторизован
              });
            }
          },
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
          onTap: () {
            if (authProvider.authorized) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LikedConfigurations(),
                ),
              );
            } else {
              setState(() {
                showLoginWindow = true;
              });
            }
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
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            } else {
              setState(() {
                showLoginWindow = true;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: authProvider.authorized
                ? SvgPicture.asset(
                    AppIcons.ProfileAuthorized,//если авторизован
                    height: 86,
                    width: 87,
                  )
                : SvgPicture.asset(
                    AppIcons.ProfileNoAuthorized,//если не авторизован
                    height: 86,
                    width: 87,
                  ),
          ),
        ),
      ],
    );
  }

  // строит основной контент главной страницы
  Widget _buildMainContent() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PC Maker 3008",
                style: TextStyle(
                  fontSize: 100,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: _calculateTextWidth(
                    "PC Maker 3008", const TextStyle(fontSize: 100)),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Мы создадим конфигурацию Вашей МЕЧТЫ!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 96),
                    InkWell(
                      onTap: () {
                        if (authProvider.authorized) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfigurationChoosePage(),
                            ),
                          );
                        } else {
                          setState(() {
                            showLoginWindow = true;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 78,
                        width: 590,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(15, 174, 150, 1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          'Приступить к сборке!',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Изображение ПК
        Image.asset(
          AppImgs.PcImagePNG,
          height: 407,
          width: 407,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  // вспомогательная функция для расчета ширины текста
  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.width;
  }
}

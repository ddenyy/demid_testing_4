// Провайдер состояния для управления авторизацией пользователя.
// Обрабатывает логин, регистрацию и хранение данных пользователя.
// Интегрируется с UserService для работы с сервером.

import 'package:appui/services/user_service.dart';
import 'package:appui/src/generated/proto_user.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';

class AuthProvider extends ChangeNotifier {
  final UserService _userService = UserService();  // Сервис для работы с пользователями
  UserResponse? _currentUser;                      // Данные текущего пользователя
  bool authorized = false;                         // Флаг авторизации
  bool _isLoading = false;                         // Флаг загрузки
  String? _error;                                  // Текст ошибки
  String User_Login = '';                          // Логин пользователя
  String User_Password = '';                       // Пароль пользователя

  UserResponse? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // обрабатывает ошибки GRPC
  Future<void> _handleError(dynamic e) async {
    if (e is GrpcError) {
      _error = _mapGrpcError(e);  // Преобразование GRPC ошибки в текст
    } else {
      _error = e.toString();      // Обычная ошибка
    }
    debugPrint('Auth error: $_error');
    return; 
  }

  // Преобразует код ошибки GRPC в читаемый текст
  String _mapGrpcError(GrpcError e) {
    switch (e.code) {
      case StatusCode.unavailable:
        return 'Сервер недоступен';
      case StatusCode.deadlineExceeded:
        return 'Таймаут соединения';
      case StatusCode.invalidArgument:
        return 'Неверные данные';
      default:
        return 'Ошибка сервера: ${e.message}';
    }
  }
  // выполняет вход пользователя
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userService
          .login(username: username, password: password)
          .timeout(const Duration(seconds: 5));  // таймаут

      if (_currentUser!.success) {
        authorized = true;  // успешная авторизация
      } else {
        authorized = false;
        _error = _currentUser!.message;  // ошибка от сервера
      }
    } catch (e) {
      authorized = false;
      await _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();  // уведомление лисенеров об изменении состояния
    }
  }

  // регистрирует нового пользователя
  Future<void> register({
    required String username,
    required String password,
    required String acceptPassword,
    required UserRole role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userService
          .register(
            username: username,
            password: password,
            acceptPassword: acceptPassword,
            role: role,
          )
          .timeout(const Duration(seconds: 5));

      if (!_currentUser!.success) {
        _error = _currentUser!.message;
      }
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Очищает текст ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Устанавливает текст ошибки
  void setError(String s) {}
}
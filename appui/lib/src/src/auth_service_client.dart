// GRPC клиент для работы с сервисом авторизации.
// Обеспечивает взаимодействие с сервером аутентификации.

import 'package:appui/src/generated/generated/auth_service.pbgrpc.dart';

import 'package:grpc/grpc_web.dart';

class AuthServiceClientWrapper {
  late AuthServiceClient stub;  // GRPC заглушка

  AuthServiceClientWrapper() {
    final channel =
        GrpcWebClientChannel.xhr(Uri.parse('http://localhost:8080'));
    stub = AuthServiceClient(channel);//инициализация клиента 
  }

  // Регистрирует нового пользователя
  Future<RegistrationResponse> register(
      String username, String password, String confirmPassword) async {
    final request = RegistrationRequest()
      ..username = username
      ..password = password
      ..confrimPassword = confirmPassword;
    return await stub.register(request);  // Отправка запроса на сервер
  }

  // Выполняет вход пользователя
  Future<LoginResponse> login(String username, String password) async {
    final request = LoginRequest()
      ..username = username
      ..password = password;
    return await stub.login(request);  // Отправка запроса на сервер
  }
}

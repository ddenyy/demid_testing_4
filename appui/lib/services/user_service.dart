// Сервис для работы с API пользователей.
// Обеспечивает взаимодействие с сервером для регистрации и авторизации.

import 'package:appui/src/generated/proto_user.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UserService {
  static const String Serveradress = 'localhost';  // Адрес сервера
  static const int Serverport = 50051;             // Порт сервера

  late final UserServiceClient _client;  // GRPC клиент

  UserService() {
    final channel = ClientChannel(
      Serveradress,
      port: Serverport,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _client = UserServiceClient(channel);  // Инициализация клиента
  }
  // Регистрирует нового пользователя
  Future<UserResponse> register({
    required String username,
    required String password,
    required String acceptPassword,
    required UserRole role,
  }) async {
    final request = RegistrationRequest()
      ..username = username
      ..password = password
      ..acceptPassword = acceptPassword
      ..role = role;
    return await _client.registration(request);  // Отправка запроса
  }

  // Выполняет вход пользователя
  Future<UserResponse> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequest()
      ..username = username
      ..password = password;
    return await _client.login(request);  // Отправка запроса
  }
}

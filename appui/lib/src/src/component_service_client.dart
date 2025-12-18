// GRPC клиент для работы с сервисом компонентов.
// Обеспечивает загрузку данных о компонентах ПК из JSON.

import 'package:appui/src/src/generated/components.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

class ComponentServiceClientWrapper {
  late ComponentSeviceClient _client;  // GRPC клиент

  ComponentServiceClientWrapper() {
    final channel = GrpcWebClientChannel.xhr(
      Uri.parse('http://localhost:8082'),
    );
    _client = ComponentSeviceClient(channel);
  }

  // Загружает компоненты из JSON файла на сервере
  Future<String> loadComponentsFromJson() async {
    try {
      final response = await _client.loadComponentsFromJson(Empty());
      return response.message;  // Возвращает сообщение от сервера
    } catch (e) {
      return 'Ошибка: $e';  // Обработка ошибок
    }
  }
}

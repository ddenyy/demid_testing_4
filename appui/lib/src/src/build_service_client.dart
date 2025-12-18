// grpc клиент для работы с сервисом сборок ПК.
// Обеспечивает получение данных о готовых конфигурациях.

import 'package:appui/src/src/generated/assembly.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

class BuildServiceClientWrapper {
  late BuildServiceClient stub;  // GRPC заглушка

  BuildServiceClientWrapper() {
    final channel = GrpcWebClientChannel.xhr(
      Uri.parse('http://localhost:8083'),
    );
    stub = BuildServiceClient(channel);//инициализация клиента
  }

  // Получает одну сборку с сервера
  Future<Build> getOneBuild() async {
    final request = Empty();  // Пустой запрос
    return await stub.getOneBuild(request);  // Получение сборки
  }
}

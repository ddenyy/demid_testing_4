import 'package:appui/src/generated/generated/auth_service.pb.dart';
import 'package:appui/src/generated/generated/auth_service.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

class AuthServiceClientWrapper {
  late AuthServiceClient stub;

  AuthServiceClientWrapper() {
    final channel =
        GrpcWebClientChannel.xhr(Uri.parse('http://localhost:8080'));
    stub = AuthServiceClient(channel);
  }

  Future<RegistrationResponse> register(
      String username, String password, String confirmPassword) async {
    final request = RegistrationRequest()
      ..username = username
      ..password = password
      ..confrimPassword = confirmPassword;
    return await stub.register(request);
  }

  Future<LoginResponse> login(String username, String password) async {
    final request = LoginRequest()
      ..username = username
      ..password = password;
    return await stub.login(request);
  }
}

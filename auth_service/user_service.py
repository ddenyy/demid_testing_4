"""gRPC сервис для аунтификации пользователя"""

import grpc
from grpc import ServicerContext
from password.entrophy import password_entrophy
from password.hash_password import check_hash_password, generate_hash_password
from code_database_user import get_user, create_user
import auth_service_pb2
import auth_service_pb2_grpc

class AuthService(auth_service_pb2_grpc.AuthServiceServicer):
    """Реализация gRPC сервиса для работы с пользователем"""

    MIN_ENTROPHY = 50

    def Register(self, request, context):
        """Обработка регистрации нового пользовтаеля"""
        if request.password != request.confrim_password :
            return auth_service_pb2.RegistrationResponse(
                success = False,
                message = "Пароли не совпадают"
            )
        entrophy = password_entrophy(request.password)
        if entrophy < self.MIN_ENTROPHY:
            return auth_service_pb2.RegistrationResponse(
                success = False,
                message = "Пароль ненадежный"
            )
        if get_user(request.username):
            return auth_service_pb2.RegistrationResponse(
                success = False,
                message = "Пользователь уже существует"
            )
        create_user(
            login = request.username,
            password_hash=generate_hash_password(request.password),
            user_role = 'user')
        
        return auth_service_pb2.RegistrationResponse(
            success = True,
            message = "Регистрация прошла успешно"
        )
    
    def Login(self, request, context):
        user = get_user(request.username)
        if not user:
            return auth_service_pb2.LoginResponse(
                success = False,
                message = "Неверный логин или пароль"
            )
        if not check_hash_password(request.password, user['password_hash']):
            return auth_service_pb2.LoginResponse(
                success = False,
                message = "Неверный логин или пароль"
            )
        return auth_service_pb2.LoginResponse(
            success = True,
            message = "Авторизация прошла успешно"
        )
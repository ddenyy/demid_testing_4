"""gRPC сервер для запуска сервиса пользователей"""

from concurrent import futures
import grpc

import auth_service_pb2_grpc
from user_service import AuthService

def serve():
    """Запуск gRPC сервера"""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    auth_service_pb2_grpc.add_AuthServiceServicer_to_server(
        AuthService(),
        server
    )
    server.add_insecure_port("[::]:50051")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
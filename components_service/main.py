"""gRPC сервер для запуска сервиса пользователей"""

from concurrent import futures
import grpc

import components_pb2_grpc
from componets_service import ComponentSevice

def serve():
    """Запуск gRPC сервера"""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    components_pb2_grpc.add_ComponentSeviceServicer_to_server(
        ComponentSevice(),
        server
    )
    server.add_insecure_port("[::]:50052")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
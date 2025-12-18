"""gRPC сервер для запуска сервиса пользователей"""

from concurrent import futures
import grpc

import assembly_pb2_grpc
from code_database import BuildService

def serve():
    """Запуск gRPC сервера"""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    assembly_pb2_grpc.add_BuildServiceServicer_to_server(
        BuildService(),
        server
    )
    server.add_insecure_port("[::]:50053")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
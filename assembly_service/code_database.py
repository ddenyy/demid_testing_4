import grpc

from sqlalchemy import create_engine, text

import assembly_pb2
import assembly_pb2_grpc

# Описание подключения к базе данных с комплектующими
DB_NAME = 'components'
DB_USER = 'postgres'
DB_PASS = 'secret'
DB_HOST = 'components_db'
DB_PORT = '5432'
DB_STRING = f'postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}'

# Описание подключения к базе данных со сборками
DB_NAME1 = 'builds'
DB_USER1 = 'postgres'
DB_PASS1 = 'secret'
DB_HOST1 = 'assembly_db'
DB_PORT1 = '5432'
DB_STRING1 = f'postgresql://{DB_USER1}:{DB_PASS1}@{DB_HOST1}:{DB_PORT1}/{DB_NAME1}'

engine_components = create_engine(DB_STRING)
engine_builds = create_engine(DB_STRING1)


class BuildService(assembly_pb2_grpc.BuildServiceServicer):
    def GetOneBuild(self, request, context):
        """Получение одной сборки ПК""" 
               
        with engine_components.connect() as conn:
            rows = conn.execute(text("""
    SELECT DISTINCT ON (type) id, name, type, manufacturer, issue, specs::text FROM components ORDER BY type, id
""")).fetchall()

        # Если нет комплектующих, возвращаем ошибку
        if not rows:
            context.set_code(grpc.StatusCode.NOT_FOUND)
            context.set_details('Нет комплектующих для сборки')
            return assembly_pb2.Build()

        # Формируем сообщения о комплектующих
        component_messages = []
        for row in rows:
            component_messages.append(
                assembly_pb2.Component(
                    id=row[0],
                    name=row[1],
                    type=row[2],
                    manufacturer=row[3],
                    issue=row[4],
                    specs_json=row[5]
                )
            )

        component_ids_str = ",".join(str(c.id) for c in component_messages)

        # Проверяем, существует ли уже такая сборка
        with engine_builds.connect() as conn_builds:
            existing = conn_builds.execute(
                text("SELECT id FROM pc_builds WHERE components_ids = :comp_ids"),
                {'comp_ids': component_ids_str}
            ).fetchone()

            if existing:
                build_id = existing[0]
            else:
                result = conn_builds.execute(
                    text("INSERT INTO pc_builds (components_ids) VALUES (:comp_ids) RETURNING id"),
                    {'comp_ids': component_ids_str}
                )
                build_id = result.fetchone()[0]
                conn_builds.commit()

        return assembly_pb2.Build(
            id=build_id,
            components=component_messages
        )
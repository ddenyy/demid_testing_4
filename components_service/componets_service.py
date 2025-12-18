import json
import grpc
from grpc import ServicerContext
from code_database import get_all_components, insert_component
import components_pb2, components_pb2_grpc
import traceback


class ComponentSevice(components_pb2_grpc.ComponentSeviceServicer):
    def AddComponent(self, request, context):
        """Добавление компонента в базу данных."""
        insert_component({
            'name':request.name,
            'type':request.type,
            'manufacturer':request.manufacturer,
            'issue': request.issue,
            'spec_json': request.spec_json
        })
        return components_pb2.ComponentResponse(message='Компоненты добавлены')
    
    def GetAllComponents(self, request, context):
        """Получение всех компонентов из базы данных."""
        components = get_all_components()
        return components_pb2.ComponentList(
            components = [
                components_pb2.Component(
                    id = comp['id'],
                    name = comp['name'],
                    type = comp['type'],
                    manufacturer = comp['manufacturer'],
                    issue = comp['issue'],
                    spec_json = comp['spec_json']
                )
                for comp in components
            ]
        )
    
    def LoadComponentsFromJson(self, request, context):
        """Загрузка компонентов из JSON файла в базу данных."""
        try:
            with open("components.json", "r", encoding="utf-8") as f:
                components = json.load(f)
                for comp in components:
                    insert_component(comp)
            return components_pb2.ComponentResponse(message='Компоненты загружены')
        except Exception as e:
            error_msg = f"Ошибка при загрузке компонентов: {e}\n{traceback.format_exc()}"
            print(error_msg)  # Логируем в консоль
            return components_pb2.ComponentResponse(message='Ошибка при загрузке компонентов')
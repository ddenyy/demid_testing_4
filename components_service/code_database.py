from sqlalchemy import create_engine
from sqlalchemy import text
import json

# Описание подключения к базе данных компонентов
DB_NAME = 'components'
DB_USER = 'postgres'
DB_PASS = 'secret'
DB_HOST = 'components_db'
DB_PORT = '5432'

DB_STRING = f'postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}'

db = create_engine(DB_STRING)

def insert_component(component):
    """Вставка компонента в базу данных."""
    if 'specs' in component and isinstance(component['specs'], dict):
        component['specs'] = json.dumps(component['specs'])
    
    with db.connect() as conn:
        conn.execute(text("""
            INSERT INTO components (name, type, manufacturer, issue, specs)
            VALUES (:name, :type, :manufacturer, :issue, :specs)
        """), component)
        conn.commit()

def get_all_components():
    """Получение всех компонентов из базы данных."""
    with db.connect() as conn:
        result = conn.execute(text("""SELECT * FROM components""")).fetchall()
        return [
            {
                'id' : row[0],
                'name' : row[1],
                'type' : row[2],
                'manufacturer' : row[3],
                'issue' : row[5],
                'specs' : row[4]
            }
            for row in result
        ]
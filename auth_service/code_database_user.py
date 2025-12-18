"Модуль реализует методы работы с базами данных"

from typing import Optional, Dict, Any
from sqlalchemy import create_engine
from sqlalchemy import text

DB_NAME = 'portal'
DB_USERS = 'postgres'
DB_PASS = 'secret'
DB_HOST = 'db'
DB_PORT = '5432'

DB_STRING = f'postgresql://{DB_USERS}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
db = create_engine(DB_STRING)

def create_user(login: str, password_hash: bytes, user_role: str) -> None:
    """Создает нового ползователя в БД

    Args:
        login (str): Логин пользователя
        password_hash (bytes): Хэш пароля
        role (str): Роль пользователя
    """
    with db.connect() as conn:
        conn.execute(text("""
            INSERT INTO users(user_login, password_hash, user_role)
            VALUES (:user_login, :password_hash, :user_role)
        """),{
            'user_login': login,
            'password_hash': password_hash,
            'user_role': user_role
        })
        conn.commit()

def get_user(login: str) -> Optional[Dict[str, Any]]:
    """Извлечение данных о пользователе

    Args:
        login (str): логин пользователя

    Returns:
        Optional[Dict[str, Any]]: Словарь данных если найден, иначе None
    """
    with db.connect() as conn:
        result = conn.execute(text("""
            SELECT * FROM users WHERE user_login = :user_login
        """),{
            'user_login': login
        }).fetchone()
        if result:
            password_hash = result[2]
            if isinstance(password_hash, memoryview):
                password_hash = password_hash.tobytes()
            return {
                'user_id': result[0],
                'user_login': result[1],
                'password_hash': password_hash,
                'user_role': result[3]
            }
        return None


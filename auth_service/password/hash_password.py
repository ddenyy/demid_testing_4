import bcrypt

"""
Модуль реалтзует хэширование 2 функции.
Вычисляет хэш пароля.
Сравнивает оригинальный пароль с его хэш версией
"""


def generate_hash_password(password: str) -> bytes:
    """
    Функция хэширует пароль
    Args:
        password(str): передаваем пароль
    Returns:
        bytes: Хэшированный пароль

    """
    salt = bcrypt.gensalt()
    hash_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hash_password


def check_hash_password(password: str, hash_password: bytes) -> bool:
    """
    Функция проверяет соответсвие пароля и его хэш версии
    Args:
        passwrd(str): передаваемый оригинальный пароль
        hash_password(bytes): передаваемая хэш версия пароля
    Returns:
        bool: True - совпадают, False - различаются
    """
    return bcrypt.checkpw(password.encode('utf-8'), hash_password)

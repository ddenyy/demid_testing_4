import math

"""Модуль для расчета энтропии паролей.
Содержит функцию для вычисления энтропии пароля в битах,
что позволяет оценить его стойкость к взлому методом перебора.
"""


def password_entrophy(password: str) -> float:
    """Фунция вычисляет энтопию пароля
    Args:
        password(str): Передаваем пароль
    Returns:
        Число энтропии
    """
    # проверка наличия различных типов символов
    lower_letter = any(c.islower() for c in password)
    up_letter = any(c.isupper() for c in password)
    digit = any(c.isdigit() for c in password)
    special_symbols = any(not c.isalnum() for c in password)

    # длина пароля
    len_password = len(password)

    # вариативность символов
    variant_symbols = 0
    if lower_letter:
        variant_symbols += 26
    if up_letter:
        variant_symbols += 26
    if digit:
        variant_symbols += 10
    if special_symbols:
        variant_symbols += 32

    if variant_symbols == 0:
        return 0.0
    # энтропия расчитывается по формуле H = L * log2(N)
    count_entrophy = len_password * math.log2(variant_symbols)
    return count_entrophy

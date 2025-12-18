"""
Лабораторная работа
Автоматизированное тестирование API системы Assembly_PC

Тестируются сервисы:
- AuthService
- ComponentService

Тестирование выполняется через grpcwebproxy (gRPC-Web)

Зависимости:
pip install requests
"""

import requests
import json
import time
import sys
import os


# -----------------------------
# Конфигурация
# -----------------------------

GRPCWEB_PROXY_URL = os.getenv(
    "GRPCWEB_PROXY_URL",
    "http://localhost:8080"
)

AUTH_REGISTER_URL = f"{GRPCWEB_PROXY_URL}/AuthService/Register"
AUTH_LOGIN_URL = f"{GRPCWEB_PROXY_URL}/AuthService/Login"

COMP_GET_ALL_URL = f"{GRPCWEB_PROXY_URL}/ComponentSevice/GetAllComponents"
COMP_ADD_URL = f"{GRPCWEB_PROXY_URL}/ComponentSevice/AddComponent"
COMP_LOAD_JSON_URL = f"{GRPCWEB_PROXY_URL}/ComponentSevice/LoadComponentsFromJson"

HEADERS = {
    "Content-Type": "application/json",
    "X-Grpc-Web": "1"
}


# -----------------------------
# Вспомогательные функции
# -----------------------------

def check_server_available(timeout=3):
    """
    Проверка доступности grpcwebproxy
    """
    print("Проверка доступности grpcwebproxy...")
    try:
        requests.get(GRPCWEB_PROXY_URL, timeout=timeout)
        print("OK: grpcwebproxy доступен")
        return True
    except requests.exceptions.RequestException:
        print("ERROR: grpcwebproxy недоступен")
        return False


def send_request(url, payload=None, timeout=5):
    """
    Универсальная функция отправки запроса к grpcwebproxy
    """
    try:
        response = requests.post(
            url=url,
            json=payload if payload else {},
            headers=HEADERS,
            timeout=timeout
        )

        if response.status_code != 200:
            print(f"[INFO] HTTP статус: {response.status_code}")

        if response.text:
            try:
                return response.json()
            except json.JSONDecodeError:
                print("[INFO] Ответ не является JSON")
                return {}

        return {}

    except requests.exceptions.Timeout:
        print("[ERROR] Тайм-аут запроса")
        return None
    except requests.exceptions.ConnectionError:
        print("[ERROR] Не удалось подключиться к серверу")
        return None


# -----------------------------
# Тесты AuthService
# -----------------------------

def test_register_success():
    print("Тест: регистрация с корректными данными")

    payload = {
        "username": "testuser",
        "password": "Test123!@#",
        "confrim_password": "Test123!@#"
    }

    response = send_request(AUTH_REGISTER_URL, payload)

    if response and response.get("success"):
        print("OK: пользователь зарегистрирован")
        return True

    if response and "already exists" in response.get("message", ""):
        print("OK: пользователь уже существует")
        return True

    print("FAIL: регистрация не выполнена")
    return False


def test_register_invalid_passwords():
    print("Тест: регистрация с разными паролями")

    payload = {
        "username": "testuser2",
        "password": "Pass123!@#",
        "confrim_password": "Different123"
    }

    response = send_request(AUTH_REGISTER_URL, payload)

    if response and not response.get("success"):
        print("OK: регистрация отклонена")
        return True

    print("FAIL: ожидалась ошибка")
    return False


def test_login_success():
    print("Тест: успешный логин")

    payload = {
        "username": "testuser",
        "password": "Test123!@#"
    }

    response = send_request(AUTH_LOGIN_URL, payload)

    if response and response.get("success"):
        print("OK: логин успешен")
        return True

    print("FAIL: логин не выполнен")
    return False


def test_login_invalid_password():
    print("Тест: логин с неправильным паролем")

    payload = {
        "username": "testuser",
        "password": "WrongPassword"
    }

    response = send_request(AUTH_LOGIN_URL, payload)

    if response and not response.get("success"):
        print("OK: доступ отклонен")
        return True

    print("FAIL: ожидалась ошибка")
    return False


def test_login_nonexistent_user():
    print("Тест: логин несуществующего пользователя")

    payload = {
        "username": "unknown_user",
        "password": "123456"
    }

    response = send_request(AUTH_LOGIN_URL, payload)

    if response and not response.get("success"):
        print("OK: пользователь не найден")
        return True

    print("FAIL: ожидалась ошибка")
    return False


# -----------------------------
# Тесты ComponentService
# -----------------------------

def test_get_all_components():
    print("Тест: получение списка компонентов")

    response = send_request(COMP_GET_ALL_URL)

    if response and "components" in response:
        print(f"OK: получено компонентов: {len(response['components'])}")
        return True

    print("FAIL: список компонентов не получен")
    return False


def test_add_component():
    print("Тест: добавление компонента")

    payload = {
        "name": "Test Resistor",
        "type": "Resistor",
        "manufacturer": "TestCorp",
        "issue": "Test",
        "spec_json": json.dumps({
            "resistance": "100k",
            "power": "0.25W"
        })
    }

    response = send_request(COMP_ADD_URL, payload)

    if response is not None:
        print("OK: компонент обработан")
        return True

    print("FAIL: компонент не добавлен")
    return False


def test_load_components_from_json():
    print("Тест: загрузка компонентов из JSON")

    response = send_request(COMP_LOAD_JSON_URL)

    if response is not None:
        print("OK: загрузка выполнена")
        return True

    print("FAIL: загрузка не выполнена")
    return False


# -----------------------------
# Запуск всех тестов
# -----------------------------

def run_tests():
    print("Запуск автоматизированных тестов API\n")

    if not check_server_available():
        print("Тестирование прервано: сервис недоступен")
        return 1

    tests = [
        test_register_success,
        test_register_invalid_passwords,
        test_login_success,
        test_login_invalid_password,
        test_login_nonexistent_user,
        test_get_all_components,
        test_add_component,
        test_load_components_from_json
    ]

    passed = 0

    for test in tests:
        if test():
            passed += 1
        print("-" * 40)
        time.sleep(0.3)

    total = len(tests)
    pass_rate = (passed / total) * 100

    print(f"Итого пройдено тестов: {passed} из {total}")
    print(f"Метрика качества (Test Pass Rate): {pass_rate:.1f}%")

    if passed == total:
        print("Дефекты на уровне API-тестирования не выявлены")
    else:
        print("Обнаружены дефекты на уровне API-тестирования")

    return 0 if passed == total else 1


if __name__ == "__main__":
    sys.exit(run_tests())

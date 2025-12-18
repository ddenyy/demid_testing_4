# Стадия сборки Flutter-приложения
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Копируем pubspec файлы и устанавливаем зависимости (кэш для ускорения)
COPY pubspec.* ./
RUN flutter pub get

# Копируем остальной код
COPY . .

# Собираем Flutter Web-приложение
RUN flutter build web --release

# Стадия nginx-сервера
FROM nginx:alpine

# Копируем собранный веб-код из предыдущего этапа
COPY --from=build /app/build/web /usr/share/nginx/html

# Открываем порт 80
EXPOSE 80

# Запуск nginx в фоне
CMD ["nginx", "-g", "daemon off;"]
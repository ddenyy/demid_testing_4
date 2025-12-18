// Кастомный виджет для отображения текста с градиентом.
// Использует ShaderMask для применения градиента к тексту.
// 
// Пример использования:
// GradientText(
//   'Hello World',
//   gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
//   style: TextStyle(fontSize: 24),
// )

import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;      // Текст для отображения
  final TextStyle? style; // Стиль текста
  final Gradient gradient; // Градиент для текста

  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,  // Применение градиента только к тексту
      shaderCallback: (bounds) => gradient.createShader(bounds),  // Создание шейдера
      child: Text(text, style: style),  // Основной текст
    );
  }
}
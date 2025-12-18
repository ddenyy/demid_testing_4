// Провайдер состояния для управления избранными сборками.
// Обеспечивает добавление/удаление сборок из списка понравившихся.

import 'package:flutter/material.dart';

class LikedProvider extends ChangeNotifier {
  final Set<int> _likedConfigs = {};  // Множество ID понравившихся сборок

  // Проверяет, находится ли сборка в избранном
  bool isLiked(int configId) {
    return _likedConfigs.contains(configId);
  }

  // Переключает статус "лайка" для сборки
  void toggleLike(int configId) {
    if (_likedConfigs.contains(configId)) {
      _likedConfigs.remove(configId);  // Удаление из избранного
    } else {
      _likedConfigs.add(configId);     // Добавление в избранное
    }
    notifyListeners();  // Уведомление слушателей об изменении
  }

  // Возвращает список ID избранных сборок
  List<int> get likedConfigs => _likedConfigs.toList();
}
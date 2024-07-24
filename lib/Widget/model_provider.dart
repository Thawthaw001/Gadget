import 'package:flutter/material.dart';

class ModelProvider with ChangeNotifier {
  String _selectedColor = '';
  String _selectedStorage = '';
  int _quantity = 0;
  List<Map<String, dynamic>> _basket = [];

  String get selectedColor => _selectedColor;
  String get selectedStorage => _selectedStorage;
  int get quantity => _quantity;
  List<Map<String, dynamic>> get basket => _basket;

  void setSelectedColor(String color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setSelectedStorage(String storage) {
    _selectedStorage = storage;
    notifyListeners();
  }

  void incrementQuantity() {
    if (_quantity < 15) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }

  bool addToCart(String modelId, String imageUrl, String name, double price,
      String selectedColor, String selectedStorage, int quantity) {
    if (_quantity <= 0 || _selectedColor.isEmpty || _selectedStorage.isEmpty) {
      return false; 
    }
    final existingItemIndex = _basket.indexWhere((item) =>
        item['modelId'] == modelId &&
        item['color'] == selectedColor &&
        item['storage'] == selectedStorage);

    if (existingItemIndex != -1) {
      _basket[existingItemIndex]['quantity'] =
          (_basket[existingItemIndex]['quantity'] as int) + _quantity;
    } else {
      final item = {
        'modelId': modelId,
        'imageUrl': imageUrl,
        'name': name,
        'price': price,
        'color': selectedColor,
        'storage': selectedStorage,
        'quantity': _quantity,
      };
      _basket.add(item);
    }
    _quantity = 0;
        resetSelections();

    notifyListeners();
    return true;
  }

  void removeFromCart(String modelId,String color,String storage){
    _basket.removeWhere((item) =>
        item['modelId'] == modelId &&
        item['color'] == color &&
        item['storage'] == storage);
    notifyListeners();
  }

  void updateQuantity(String modelId, int quantity) {
    for (var item in _basket) {
      if (item['modelId'] == modelId) {
        item['quantity'] = quantity;
        break;
      }
    }
    notifyListeners();
  }


    void resetSelections() {
    _selectedColor = '';
    _selectedStorage = '';
    _quantity = 0;
    notifyListeners();
  }
}

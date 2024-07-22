// import 'package:flutter/foundation.dart';

// class ModelProvider with ChangeNotifier {
//   String _selectedColor = '';
//   String _selectedStorage = '';
//   int _quantity = 0; // Default quantity

//   String get selectedColor => _selectedColor;
//   String get selectedStorage => _selectedStorage;
//   int get quantity => _quantity;

//   void setSelectedColor(String color) {
//     _selectedColor = color;
//     notifyListeners();
//   }

//   void setSelectedStorage(String storage) {
//     _selectedStorage = storage;
//     notifyListeners();
//   }

//   void incrementQuantity() {
//     if (_quantity < 15) {
//       _quantity++;
//       notifyListeners();
//     }
//   }

//   void decrementQuantity() {
//     if (_quantity > 1) {
//       _quantity--;
//       notifyListeners();
//     }
//   }

//   void addToCart(String modelId) {
//     // Implement add to cart logic, respecting the quantity limit
//     // Use BasketProvider to add items to the cart
//   }
// }
import 'package:flutter/foundation.dart';

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

  void addToCart(String modelId, String imageUrl, String name, double price, String selectedColor, String selectedStorage) {
    final item = {
      'modelId': modelId,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'color': _selectedColor,
      'storage': _selectedStorage,
      'quantity': _quantity,
    };
    _basket.add(item);
    notifyListeners();
  }

  void removeFromCart(String modelId) {
    _basket.removeWhere((item) => item['modelId'] == modelId);
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
}

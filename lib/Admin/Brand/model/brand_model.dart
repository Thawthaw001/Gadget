class Model {
  final String name;
  final double price;
  final String specs;
  final String imageUrl;
  final List<String> colors;
  final List<String> storageOptions;
  final bool inStock;
  final int quantity;

  Model({
    required this.name,
    required this.price,
    required this.specs,
    required this.imageUrl,
    required this.colors,
    required this.storageOptions,
    required this.inStock,
    required this.quantity
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'specs': specs,
      'imageUrl': imageUrl,
      'colors': colors,
      'storageOptions': storageOptions,
      'inStock': inStock,
      'quantity':quantity
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      name: map['name'],
      price: map['price'],
      specs: map['specs'],
      imageUrl: map['imageUrl'],
      colors: List<String>.from(map['colors']),
      storageOptions: List<String>.from(map['storageOptions']),
      inStock: map['inStock'],
      quantity: map['quantity']
    );
  }
}

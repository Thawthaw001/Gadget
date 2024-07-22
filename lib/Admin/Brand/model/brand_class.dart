class Brand {
  final String name;
  final String imageUrl;
  final List<String> colors;
  final List<String> storageOptions;
  final bool inStock;
  final int quantity;

  Brand({
    required this.quantity,
    required this.name,
    required this.imageUrl,
    required this.colors,
    required this.storageOptions,
    required this.inStock,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'colors': colors,
      'storageOptions': storageOptions,
      'inStock': inStock,
      'quantity': quantity,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      name: map['name'],
      imageUrl: map['imageUrl'],
      colors: List<String>.from(map['colors']),
      storageOptions: List<String>.from(map['storageOptions']),
      inStock: map['inStock'],
      quantity: map['quantity'],
    );
  }
}

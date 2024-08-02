class BasketItem {
  final String modelId;
  final String imageUrl;
  final String name;
  final double price;
  final String color;
  final String storage;
  final int quantity;

  BasketItem({
    required this.modelId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.color,
    required this.storage,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'modelId': modelId,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'color': color,
      'storage': storage,
      'quantity': quantity,
    };
  }
}

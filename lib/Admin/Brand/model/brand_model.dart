class Model {
  String name;
  double price;
  String specification;
  final List<String> colors;
  final List<String> storageOptions;
  final bool inStock; 

  Model({required this.name, required this.price, required this.specification,required this.colors,required this.inStock,required this.storageOptions});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'specification': specification,
      'colors':colors,
      'inStock':inStock,
      'storageOptions':storageOptions
      
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      name: map['name'],
      price: map['price'],
      specification: map['specification'],
      colors: map['colors'],
      inStock: map['instock'],
      storageOptions: map['storageOptions']
    );
  }
}
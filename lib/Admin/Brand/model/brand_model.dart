class Model {
  String name;
  double price;
  String specification;

  Model({required this.name, required this.price, required this.specification});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'specification': specification,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      name: map['name'],
      price: map['price'],
      specification: map['specification'],
    );
  }
}

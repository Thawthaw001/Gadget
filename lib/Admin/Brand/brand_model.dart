class Brand {
  final String name;
  final List<Model> models;
  Brand({required this.name, required this.models});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'models': models.map((model) => model.toMap()).toList(),
    };
  }
}

//Model model
class Model {
  final String name;
  final double price;
  final String specification;
  Model({required this.name, required this.price, required this.specification});
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'specification': specification};
  }
}

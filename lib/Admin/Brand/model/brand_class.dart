import 'package:thaw/Admin/Brand/model/brand_model.dart';

class Brand {
  String name;
  List<Model> models;

  Brand({required this.name, required this.models});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'models': models.map((model) => model.toMap()).toList(),
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      name: map['name'],
      models: List<Model>.from(
          map['models']?.map((model) => Model.fromMap(model)) ?? []),
    );
  }
}

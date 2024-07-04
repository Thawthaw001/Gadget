class FourCategory {
  final String name;
  final String imageUrl;
  FourCategory({required this.name, required this.imageUrl});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class ProductModel {
  String? uid;
  String? name;
  String? model;
  double? price;
  String? category;
  String? description;
  List<Map<String, dynamic>>? sizes;
  List<String>? images;

  ProductModel({
    this.uid,
    this.name,
    this.model,
    this.price,
    this.category,
    this.description,
    this.sizes,
    this.images,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      uid: map['uid'],
      name: map['name'],
      model: map['model'],
      price: double.parse(map['price'].toString()),
      category: map['category'],
      description: map['description'],
      sizes: List<Map<String, dynamic>>.from(map['sizes'] ?? []),
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'model': model,
        'price': price,
        'category': category,
        'description': description,
        'sizes': sizes,
        'images': images,
      };
}

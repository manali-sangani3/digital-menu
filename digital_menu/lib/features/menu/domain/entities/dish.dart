class Dish {
  final String id;
  final String name;
  final double price;
  final String photoUrl;
  final String categoryId;
  final int? createdAt;

  const Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.photoUrl,
    required this.categoryId,
    this.createdAt,
  });
}

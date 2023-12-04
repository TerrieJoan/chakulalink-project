class CategoryModel {
  String id;
  String categoryName;
  int? wishlistStatus;
  String? entityId;
  CategoryModel({
    required this.id,
    required this.categoryName,
    this.wishlistStatus,
    this.entityId,
  });
}

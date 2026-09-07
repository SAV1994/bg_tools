class ListItemData {
  final int? id;
  final String name;
  final int copiesNum;
  final String? imagePath;

  ListItemData({
    this.id,
    required this.name,
    required this.copiesNum,
    this.imagePath,
  });
}

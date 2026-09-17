class ListItemMutableData {
  int? id;
  String name;
  int copiesNum;
  String? imagePath;

  ListItemMutableData({
    this.id,
    required this.name,
    required this.copiesNum,
    this.imagePath,
  });
}

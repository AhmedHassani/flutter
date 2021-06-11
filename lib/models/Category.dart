class Category {
  String image;
  String active;
  int categoryCODE;
  String categoryNAME;
  String showMENU;

  Category(
      {this.image,
        this.active,
        this.categoryCODE,
        this.categoryNAME,
        this.showMENU});

  Category.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    active = json['active'];
    categoryCODE = json['category_CODE'];
    categoryNAME = json['category_NAME'];
    showMENU = json['show_MENU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['active'] = this.active;
    data['category_CODE'] = this.categoryCODE;
    data['category_NAME'] = this.categoryNAME;
    data['show_MENU'] = this.showMENU;
    return data;
  }
}

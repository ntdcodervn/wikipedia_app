class Wikipedia {
  int id;
  String key;
  String title;
  String excerpt;
  String description;
  String thumbnail;

  Wikipedia(
      {this.id,
      this.key,
      this.title,
      this.excerpt,
      this.description,
      this.thumbnail});

  Wikipedia.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'] : "";
    key = json['key'] != null ? json['key'] : "";
    title = json['title'] != null ? json['title'] : "";
    excerpt = json['excerpt'] != null ? json['excerpt'] : "";
    description = json['description'] != null ? json['description'] : "";
    thumbnail = json['thumbnail'] != null ? json['thumbnail']['url'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['title'] = this.title;
    data['excerpt'] = this.excerpt;
    data['description'] = this.description;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

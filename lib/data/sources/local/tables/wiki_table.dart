class WikiTable {
  static final String tableName = 'wiki';
  static final String columnId = 'id';
  static final String columnKey = 'key';
  static final String columnTitle = 'title';
  static final String columnExcerpt = 'excerpt';
  static final String columnDescription = 'description';
  static final String columnThumbnail = 'thumbnail';

  int id;
  String title;
  String key;
  String excerpt;
  String description;
  String thumbnail;

  Map toJson() => {
        columnId: id,
        columnTitle: title,
        columnKey: key,
        columnExcerpt: excerpt,
        columnDescription: description,
        columnThumbnail: thumbnail
      };

  static List<WikiTable> fromJsonList(List<dynamic> json) =>
      json.map((i) => WikiTable.fromJson(i)).toList();

  WikiTable.fromJson(Map<String, dynamic> json) {
    id = json[columnId];
    title = json[columnTitle];
    key = json[columnKey];
    excerpt = json[columnExcerpt];
    description = json[columnDescription];
    thumbnail = json[columnThumbnail];
  }

  static String create() {
    return "CREATE TABLE IF NOT EXISTS $tableName (" +
        "$columnId INTEGER PRIMARY KEY,"
            "$columnTitle TEXT,"
            "$columnKey TEXT,"
            "$columnExcerpt TEXT,"
            "$columnDescription TEXT,"
            "$columnThumbnail TEXT"
            ")";
  }
}

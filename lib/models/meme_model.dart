class Meme {
  final int? id; 
  final String desc; // описание мема
  final String imageUrl; // ссылка на мем

  Meme({this.id, required this.desc, required this.imageUrl});

  // JSON -> Meme
  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(desc: json['description'], imageUrl: json['url']);
  }
}

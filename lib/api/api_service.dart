import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lolify/models/meme_model.dart'; 

// Ошибки:
// - неправильный url
// - нет интернета
// - api полетел
// - нет квот

class ApiService {
  // сгенерировать мем
  Future<Meme> generateMeme() async {
    String apiKey = dotenv.env['API_KEY']!;
    final response = await http.get(
      Uri.parse(
        'https://api.humorapi.com/memes/random?api-key=$apiKey&media-type=image/jpeg',
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      Meme meme = Meme.fromJson(jsonData);
      return meme;
    } else {
      throw Exception('Мем не был загружен!');
    }
  }

  // получить мемы по фильтру
  Future<List<Meme>> getMemesByFilter(String filter, int count) async {
    String apiKey = dotenv.env['API_KEY']!;
    final response = await http.get(
      Uri.parse(
        'https://api.humorapi.com/memes/search?api-key=$apiKey&media-type=image/jpeg&keywords=$filter&number=$count',
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<Meme> memes = (jsonData['memes'] as List)
          .map((memeJson) => Meme.fromJson(memeJson))
          .toList();
      return memes;
    } else {
      throw Exception('Mемы не были загружены!');
    }
  }
}

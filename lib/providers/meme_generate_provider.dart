import 'package:flutter/material.dart';
import 'package:lolify/api/api_service.dart';
import 'package:lolify/models/meme_model.dart';

class MemeGenerateProvider extends ChangeNotifier {
  final ApiService api = ApiService();
  Meme? currentMeme;
  bool _isLoading = false;

  Meme? get getMeme => currentMeme;
  bool get getLoad => _isLoading;

  set setMeme(Meme? meme) {
    currentMeme = meme;
    notifyListeners();
  }

  set setLoad(bool load) {
    _isLoading = load;
  }

  // сгенерировать мем
  Future<void> generateMeme() async {
    try {
      setLoad = true;
      notifyListeners();
      Meme newMeme = await api.generateMeme();
      setLoad = false;
      setMeme = newMeme;
    } catch (e) {
      setLoad = false;
      notifyListeners();
      throw Exception('Ошибка при загрузке мема: $e');
    }
  }
}

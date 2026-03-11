import 'package:flutter/material.dart';
import 'package:lolify/api/api_service.dart';
import 'package:lolify/models/meme_model.dart';

class MemesSearchProvider extends ChangeNotifier {
  final ApiService api = ApiService();
  List<Meme> currentMemes = [];
  bool _isLoading = false;

  String _currentCategory = 'lol';
  int _currentCount = 1;

  List<Meme> get getMemes => currentMemes;
  bool get getLoad => _isLoading;
  String get getCategory => _currentCategory;
  int get getCount => _currentCount;

  set setMemes(List<Meme> memes) {
    currentMemes = memes;
    notifyListeners();
  }

  set setLoad(bool load) {
    _isLoading = load;
  }

  set setCategory(String category) {
    _currentCategory = category;
  }

  set setCount(int count) {
    _currentCount = count;
  }

  // получить мемы по фильтру
  Future<void> getMemesByFilter() async {
    try {
      setLoad = true;
      notifyListeners();
      List<Meme> newMemes = await api.getMemesByFilter(getCategory, getCount);
      setLoad = false;
      setMemes = newMemes;
    } catch (e) {
      setLoad = false;
      notifyListeners();
      throw Exception('Ошибка при загрузке мемов: $e'); 
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lolify/db/db_service.dart';
import 'package:lolify/models/meme_model.dart';

class MemesFavouriteProvider extends ChangeNotifier {
  final DataBaseService dbService = DataBaseService();
  List<Meme> currentMemes = [];
  bool _isLoading = false;

  List<Meme> get getMemes => currentMemes;
  bool get getLoad => _isLoading;

  set setMemes(List<Meme> memes) {
    currentMemes = memes;
    notifyListeners();
  }

  set setLoad(bool load) {
    _isLoading = load;
  }

  // загрузить избранные мемы
  Future<void> getMemesFromDB() async {
    try {
      setLoad = true;
      notifyListeners();
      List<Meme> newMemes = await dbService.getAllMemes();
      setLoad = false;
      setMemes = newMemes;
    } catch (e) {
      setLoad = false;
      notifyListeners();
      throw Exception('Ошибка при загрузке мемов: $e');
    }
  }

  // добавить мем
  Future<void> addMeme(String desc, String imageUrl) async {
    try {
      await dbService.insertMeme(desc, imageUrl); 
    } catch (e) {
      throw Exception('Ошибка при добавлений мема: $e');
    }
  }

  // удалить мем
  Future<void> deleteMeme(int id) async {
    try {
      await dbService.deleteMeme(id);
      await getMemesFromDB();
    } catch (e) {
      throw Exception('Ошибка при удалений мема: $e');
    }
  }
}

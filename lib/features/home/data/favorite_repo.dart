import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteRepo {
  FavoriteRepo._();
  static final FavoriteRepo _instance = FavoriteRepo._();
  final _boxName = "favorite_list";

  factory FavoriteRepo() {
    return _instance;
  }
  late final Box favBox = Hive.box(_boxName);

  Future<void> initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<void> saveSong(int id) async {
    await favBox.put(id, '');
  }

  Future<List<int>> getAllSongsId() async {
    return favBox.keys.cast<int>().toList();
  }

  Future<void> removeSong(int id) async {
    if (favBox.containsKey(id)) {
      await favBox.delete(id);
    }
  }
}

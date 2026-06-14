import '../database/database_helper.dart';
import '../models/first_aid_guide.dart';

class FirstAidRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<FirstAidGuide>> getAllGuides() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('first_aid_guides');
    return maps.map((map) => FirstAidGuide.fromMap(map)).toList();
  }

  Future<List<FirstAidGuide>> searchGuides(String query) async {
    final db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'first_aid_guides',
      where: 'title LIKE ? OR description LIKE ? OR content LIKE ? OR keywords LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );

    return maps.map((map) => FirstAidGuide.fromMap(map)).toList();
  }
}

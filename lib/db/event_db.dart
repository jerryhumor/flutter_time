import 'package:flutter_time/model/base/models.dart';
import 'package:sqflite/sqflite.dart';

const EVENT_DB_NAME = 'time_event.db';
const EVENT_TABLE_NAME = 'events';

class EventDB {

  static EventDB _instance = null;

  EventDB._();

  Database _database;
  bool _initialized = false;

  static Future<EventDB> open() async {
    if (_instance == null) _instance = EventDB._();

    if (_instance._initialized) return _instance;
    
    await _instance._init();

    return _instance;
  }

  Future<void> _init() async {
    final databasesPath = getDatabasesPath();
    final eventDbPath = '$databasesPath/$EVENT_DB_NAME';
    _database = await openDatabase(eventDbPath);
    await _createEventTable(_database);
    _initialized = true;
  }

  /// 创建数据库表
  Future<void> _createEventTable(Database db) async {
    db.execute(
      ''' 
      CREATE TABLE IF NOT EXISTS $EVENT_TABLE_NAME (
      'id' INTEGER PRIMARY KEY AUTOINCREMENT,
      'archived' INTEGER NOT NULL DEFAULT 0,
      'deleted' INTEGER NOT NULL DEFAULT 0,
      'color' INTEGER NOT NULL,
      'title' VARCHAR(255) NOT NULL,
      'remark' VARCHAR(255) NOT NULL,
      'startTime' INTEGER NOT NULL,
      'endTime' INTEGER NOT NULL DEFAULT -1,
      'type' INTEGER NOT NULL
      );
      '''
    );
  }

  /// 获取事件
  Future<List<TimeEventModel>> fetchEvents() async {
    final List<Map<String, dynamic>> cursor = await _database.rawQuery(
        'SELECT * FROM $EVENT_TABLE_NAME WHERE archived = 0 AND deleted = 0 ORDER BY id DESC');
    final List<TimeEventModel> events = [];
    
    if (cursor == null || cursor.isEmpty) return events;
    
    cursor.forEach((element) {
      events.add(TimeEventModel.fromMap(element));
    });
    
    return events;
  }

  /// 保存事件
  Future<int> saveEvent(TimeEventModel model) async {
    return await _database.insert(EVENT_TABLE_NAME, model.toMap());
  }

  /// 修改事件
  Future<int> updateEvent(TimeEventModel model) async {
    return await _database.update(
      EVENT_TABLE_NAME,
      model.toUpdateMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  /// 归档事件
  Future<int> archiveEvent(TimeEventModel model) async {
    if (model.archived) return 0;
    model.archived = true;
    return await updateEvent(model);
  }

  /// 删除事件
  Future<int> deleteEvent(TimeEventModel model) async {
    if (model.deleted) return 0;
    model.deleted = true;
    return await updateEvent(model);
  }

  Future<void> close() async {
    await _database.close();
  }
}
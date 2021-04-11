import 'package:flutter_time/db/event_db.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';

class EventListModel {

  EventDB db;
  bool initialized = false;
  List<TimeEventModel> models = [];

  Future<void> fetchEvents() async {
    if (db == null) db = await EventDB.open();
    models = await db.fetchEvents();
    initialized = true;
    return models;
  }

  Future<int> insertEvent(TimeEventModel model) async {
    final int res = await db.saveEvent(model);
    if (res > 0) await fetchEvents();
    return res;
  }

  int get eventLength => models.length;

  Future<void> close() async {
    if (db != null) await db.close();
  }

}
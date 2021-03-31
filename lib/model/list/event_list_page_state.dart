import 'package:flutter_time/db/event_db.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';

class EventListModel {

  EventDB db;
  bool initialized = false;
  List<EventWrap> eventWraps = [];

  Future<void> fetchEvents() async {
    eventWraps = [];
    if (db == null) db = await EventDB.open();
    List<TimeEventModel> models = await db.fetchEvents();
    models.forEach((element) {
      eventWraps.add(EventWrap(TimeEventOrigin.init, element));
    });
    initialized = true;
    return eventWraps;
  }

  void insertEvent(int index, EventWrap eventWrap) {
    eventWraps.insert(index, eventWrap);
    db.saveEvent(eventWrap.model);
  }

  int get eventLength => eventWraps.length;

  Future<void> close() async {
    if (db != null) await db.close();
  }

}
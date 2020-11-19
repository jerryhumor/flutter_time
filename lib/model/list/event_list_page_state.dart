import 'package:flutter_time/pages/time_event_list_page.dart';

class EventListPageState {

  bool initialized = false;
  List<EventWrap> modelList = [];

  void insertEvent(int index, EventWrap eventWrap) {
    modelList.insert(index, eventWrap);
  }

  void addInitEvents(List<EventWrap> eventWrapList) {
    modelList.addAll(eventWrapList);
    initialized = true;
  }

  int get eventLength => modelList.length;

}
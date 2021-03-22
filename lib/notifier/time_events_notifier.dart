import 'package:flutter/widgets.dart';
import 'package:flutter_time/model/base/models.dart';

class TimeEventsNotifier with ChangeNotifier {

  List<TimeEventModel> models = [];

  bool initialized = false;

  void init(List<TimeEventModel> models) {
    initialized = true;
    models.clear();
    models.addAll(models);
    notifyListeners();
  }

  void add(TimeEventModel model) {
    models.add(model);
    notifyListeners();
  }

  void move(TimeEventModel model) {
    if (models.remove(model)) notifyListeners();
  }

}
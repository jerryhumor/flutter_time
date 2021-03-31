import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/model/list/event_list_page_state.dart';

class GlobalBloc extends BlocBase {

  EventListModel eventListModel = EventListModel();

  @override
  void dispose() {
    eventListModel.close();
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_time/value/colors.dart';

class TimeEventListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: colorGrey,
            ),
            onPressed: () {},
          )
        ],
      ),
//      body: ,
    );
  }
}

// 事件条目
class TimeEventItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


/// 时间事件model
class TimeEventModel {
  /// 数据库的id
  int id;
  /// 已归档标志
  bool archived;
  /// 已删除标志
  bool deleted;

  /// 背景颜色
  int color;

  /// 标题
  String title;

  /// 备注
  String remark;

  /// 开始时间 时间戳 精确到毫秒
  int startTime;

  /// 结束时间 时间戳 精确到毫秒
  /// 累计日中 这个值为null
  int endTime;

  /// 类型 区分累计日还是倒计日
  int type;

  TimeEventModel({
    this.id,
    this.archived = false,
    this.deleted = false,
    this.color,
    this.title,
    this.remark,
    this.startTime,
    this.endTime,
    this.type,
  });

  factory TimeEventModel.fromMap(Map<String, dynamic> map) {
    return TimeEventModel(
      id: map['id'],
      archived: map['archived'] > 0 ? true : false,
      deleted: map['deleted'] > 0 ? true : false,
      color: map['color'],
      title: map['title'],
      remark: map['remark'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'archived': archived ? 1 : 0,
      'deleted': deleted ? 1 : 0,
      'color': color,
      'title': title,
      'remark': remark,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'archived': archived ? 1 : 0,
      'deleted': deleted ? 1 : 0,
      'color': color,
      'title': title,
      'remark': remark,
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
    };
  }
}

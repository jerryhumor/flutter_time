/// 时间事件model
class TimeEventModel {
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
    this.color,
    this.title,
    this.remark,
    this.startTime,
    this.endTime,
    this.type,
  });
}

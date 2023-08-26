class IcaHistory {
  final int? icaHistoryId;
  final String readDatetime;
  final String date;
  final String rideTime;
  final String dropTime;
  final int diffMoney;
  final int restMoney;

  const IcaHistory({
    this.icaHistoryId,
    required this.readDatetime,
    required this.date,
    required this.rideTime,
    required this.dropTime,
    required this.diffMoney,
    required this.restMoney,
  });

  static IcaHistory fromJson(Map<String, Object?> map) => IcaHistory(
        icaHistoryId: map['ica_history_id'] as int,
        readDatetime: map['read_datetime'] as String,
        date: map['date'] as String,
        rideTime: map['ride_time'] as String,
        dropTime: map['drop_time'] as String,
        diffMoney: map['diff_money'] as int,
        restMoney: map['rest_money'] as int,
      );

  Map<String, Object?> toJson() => {
        'ica_history_id': icaHistoryId,
        'read_datetime': readDatetime,
        'date': date,
        'ride_time': rideTime,
        'drop_time': dropTime,
        'diff_money': diffMoney,
        'rest_money': restMoney,
      };
}

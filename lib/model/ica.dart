import 'package:ica_reader/model/ica_history.dart';
import 'package:intl/intl.dart';

class IcaRecord {
  final List<int> rawData;
  late DateTime date;
  late String rideTime;
  late String dropTime;
  late int diffMoney;
  late int restMoney;

  IcaHistory toIcaHistory() {
    final now = DateTime.now();
    final readDatetime = DateFormat('yyyyMMddHHmmss').format(now);
    final dateString = DateFormat('yyyyMMdd').format(date);

    return IcaHistory(
      readDatetime: readDatetime,
      date: dateString,
      rideTime: rideTime,
      dropTime: dropTime,
      diffMoney: diffMoney,
      restMoney: restMoney,
    );
  }

  IcaRecord({required this.rawData}) {
    date = _parseDate(rawData.sublist(0, 2));
    rideTime = _parseTime(rawData[5]);
    dropTime = _parseTime(rawData[2]);
    diffMoney = _parseUseMoney(rawData.sublist(11, 13));
    restMoney = _parseRestMoney(rawData.sublist(13, 15));
  }

  DateTime _parseDate(List<int> list) {
    final year = ((list[0] >>> 1) & 0x7F) + 2000;
    var month = 0;
    if ((list[0] & 0x01) == 1) {
      month = month + 8;
    }
    month = month + ((list[1] >>> 5) & 0x07);
    int day = (list[1] & 0x1F);

    return DateTime(year, month, day);
  }

  String _parseTime(int value) {
    if (value == 0) return '';
    value = value * 10;
    var hour = (value / 60).truncate().toString().padLeft(2, '0');
    var minute = (value % 60).toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  int _parseUseMoney(List<int> list) {
    int use = 0;
    int high = list[0] & 0x0F;
    bool isMinus = high >= 0x08;
    use = use | (high << 8);
    use = use | list[1];
    use = use & 0x0fff;
    if (isMinus) {
      use = use | 0xfffffffffffff000;
    }
    return use * 10;
  }

  int _parseRestMoney(List<int> list) {
    return list[0] * 256 + list[1];
  }
}

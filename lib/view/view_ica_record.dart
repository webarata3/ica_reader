import 'package:ica_reader/model/ica_history.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String viewDate(DateTime date) {
  return DateFormat('yyyy年MM月dd日', 'ja_JP').format(date);
}

String viewDateTime(DateTime date) {
  return DateFormat('yyyy年MM月dd日 HH:mm', 'ja_JP').format(date);
}

String viewStringDatetime(String stringDatetime) {
  var year = int.parse(stringDatetime.substring(0, 4));
  var month = int.parse(stringDatetime.substring(4, 6));
  var day = int.parse(stringDatetime.substring(6, 8));
  var hour = int.parse(stringDatetime.substring(8, 10));
  var minute = int.parse(stringDatetime.substring(10, 12));
  return viewDateTime(DateTime(year, month, day, hour, minute));
}

String viewStringDate(String stringDate) {
  var year = int.parse(stringDate.substring(0, 4));
  var month = int.parse(stringDate.substring(4, 6));
  var day = int.parse(stringDate.substring(6, 8));
  return viewDate(DateTime(year, month, day));
}

Widget viewIcaHistory(IcaHistory icaHistory) {
  final formatter = NumberFormat('#,###');
  var diffMoney = '${formatter.format(icaHistory.diffMoney)}円';
  var restMoney = '${formatter.format(icaHistory.restMoney)}円';
  var isCharge = icaHistory.diffMoney > 0;
  var title = isCharge ? '積増' : '乗車';
  var time = isCharge
      ? icaHistory.dropTime
      : '${icaHistory.rideTime}-${icaHistory.dropTime}';
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                const Text(
                  '読込日時:',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  viewStringDatetime(icaHistory.readDatetime),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Text(
                  '$title日時:',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  '${viewStringDate(icaHistory.date)} $time',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(width: 10.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 1.0),
                border: Border.all(color: const Color.fromRGBO(0, 0, 0, 1.0)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                '残額',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(2.0),
              child: Text(
                restMoney,
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

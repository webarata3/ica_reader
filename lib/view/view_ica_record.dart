import 'package:ica_reader/model/ica_history.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String viewDate(DateTime date) {
  return DateFormat('yyyy年MM月dd日', 'ja_JP').format(date);
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
  var title = isCharge ? '積増' : '運賃';
  var titleColor = isCharge ? Colors.blue : Colors.red;
  var time = isCharge
      ? icaHistory.dropTime
      : '${icaHistory.rideTime}-${icaHistory.dropTime}';
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              viewStringDate(icaHistory.date),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 14,
              ),
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
                color: titleColor,
                border: Border.all(color: titleColor),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(2.0),
              child: Text(
                diffMoney,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
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

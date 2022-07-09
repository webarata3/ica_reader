import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../model/ica.dart';

class IcaHistoryPage extends StatelessWidget {
  const IcaHistoryPage({Key? key, required this.icaRecords}) : super(key: key);

  final List<IcaRecord> icaRecords;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja_JP');

    return Scaffold(
      appBar: AppBar(
        title: const Text('ICa残高照会'),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(255, 243, 243, 1.0),
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1.0),
                    border: Border.all(
                      color: const Color.fromRGBO(220, 220, 220, 1.0),
                    ),
                  ),
                  child: viewIcaRecord(icaRecords[index]),
                );
              },
              itemCount: icaRecords.length),
        ),
      ),
    );
  }

  String viewDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日', 'ja_JP').format(date);
  }

  Widget viewIcaRecord(IcaRecord icaRecord) {
    final formatter = NumberFormat('#,###');
    var diffMoney = '${formatter.format(icaRecord.diffMoney)}円';
    var restMoney = '${formatter.format(icaRecord.restMoney)}円';
    var isCharge = icaRecord.diffMoney > 0;
    var title = isCharge ? '積増' : '運賃';
    var titleColor = isCharge ? Colors.blue : Colors.red;
    var time = isCharge
        ? icaRecord.dropTime
        : '${icaRecord.rideTime}-${icaRecord.dropTime}';
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                viewDate(icaRecord.date),
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
}

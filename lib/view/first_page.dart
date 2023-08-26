import 'package:ica_reader/helper/db_helper.dart';
import 'package:ica_reader/model/ica_history.dart';
import 'package:ica_reader/view/view_ica_record.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import '../felica/felica.dart';
import '../model/ica.dart';
import 'ica_hisotry_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _nfcFReader = NfcFReader();
  List<IcaRecord>? _icaRecords;
  List<IcaHistory>? _icaHistories;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja_JP');
    _readHisories();
  }

  @override
  void dispose() {
    DbHelper.instance.closeDatabase();
    super.dispose();
  }

  void _readHisories() async {
    _icaHistories = await DbHelper.instance.selectAll();
    setState(() {});
  }

  void _save() async {
    if (_icaRecords == null || _icaRecords!.isEmpty) return;
    _readHisories();
    if (_icaHistories!.length >= 10) {
      await DbHelper.instance.delete(_icaHistories!.last.icaHistoryId!);
    }
    var icaHistory = _icaRecords!.first.toIcaHistory();
    await DbHelper.instance.create(icaHistory);
    setState(() {
      _icaHistories!.insert(0, icaHistory);
    });
  }

  Future<void> readIca(NfcTag tag) async {
    NfcF? nfcf = NfcF.from(tag);
    if (nfcf != null) {
      try {
        _icaRecords = await _nfcFReader.readICaHistory(nfcf);
        _save();
      } catch (e) {
        print(e);
      }
    }
    setState(() {});
    await NfcManager.instance.stopSession();
    if (!mounted) return;
    if (_icaRecords == null) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IcaHistoryPage(icaRecords: _icaRecords!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text('メニュー'),
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('OSSライセンス'),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('ICa残高照会'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _nfcFReader.readTag(readIca);
                  },
                  child: const Text('ICa読み取り開始'),
                ),
              ),
            ),
            Expanded(flex: 2, child: _viewIcaHistories()),
          ],
        ),
      ),
    );
  }

  Widget _viewIcaHistories() {
    return Column(
      children: [
        const Text(
          '読み込み履歴',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10.0),
        _viewIcaHistoriesHead(),
      ],
    );
  }

  Widget _viewIcaHistoriesHead() {
    if (_icaHistories == null) {
      return const Text('読み取り中です。');
    }
    if (_icaHistories!.isEmpty) {
      return const Text('履歴はありません。');
    }
    return _viewIcaHistoriesList();
  }

  String _viewReadDate(String readDate) {
    int year = int.parse(readDate.substring(0, 4));
    int month = int.parse(readDate.substring(4, 6));
    int day = int.parse(readDate.substring(6, 8));
    int hour = int.parse(readDate.substring(8, 10));
    int minute = int.parse(readDate.substring(10, 12));

    var datetime = DateTime(year, month, day, hour, minute);

    return DateFormat('yyyy年MM月dd日 HH:mm', 'ja_JP').format(datetime);
  }

  Widget _viewIcaHistoriesList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                    '読み込み日時: ${_viewReadDate(_icaHistories![index].readDatetime)}'),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(40.0, 5.0, 15.0, 5.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1.0),
                  border: Border.all(
                    color: const Color.fromRGBO(220, 220, 220, 1.0),
                  ),
                ),
                child: viewIcaHistory(_icaHistories![index]),
              ),
            ],
          );
        },
        itemCount: _icaHistories!.length,
      ),
    );
  }
}

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja_JP');
  }

  Future<void> readIca(NfcTag tag) async {
    NfcF? nfcf = NfcF.from(tag);
    if (nfcf != null) {
      try {
        _icaRecords = await _nfcFReader.readICaHistory(nfcf);
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
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              _nfcFReader.readTag(readIca);
            },
            child: const Text('ICa読み取り開始'),
          ),
        ),
      ),
    );
  }
}

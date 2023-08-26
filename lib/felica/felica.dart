import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import 'dart:typed_data';

import '../model/ica.dart';

class NfcFReader {
  static const _systemCode = [0x80, 0xEF];
  static const _serviceCode = [0x8F, 0x89];

  FeliCa? felica;

  void readTag(Future<void> Function(NfcTag tag) callback) async {
    await NfcManager.instance.startSession(onDiscovered: callback);
  }

  Future<List<IcaRecord>> readICaHistory(NfcF nfcf) async {
    var pollingCommand = _polling(_systemCode);
    var pollingRes = await nfcf.transceive(data: pollingCommand);
    var idm = pollingRes.sublist(2, 10);

    var icaRecords = <IcaRecord>[];

    for (int i = 0; i < 20; i++) {
      var readCommand = _readWithoutEncryption(idm, i);
      var res = await nfcf.transceive(data: readCommand);
      var ret = res.sublist(13, res.length).toList();
      var icaRecord = IcaRecord(rawData: ret);
      icaRecords.add(icaRecord);
    }

    return icaRecords;
  }

  Uint8List _polling(systemCode) {
    final req = <int>[];

    req.add(0x00); // pollingのリクエストコマンド
    req.add(systemCode[0]);
    req.add(systemCode[1]);
    req.add(0x01); // pollingのレスポンスコード
    req.add(0x00); // タイムスロット
    req.insert(0, req.length + 1); // 先頭をサイズに変更

    return Uint8List.fromList(req);
  }

  Uint8List _readWithoutEncryption(Uint8List idm, int addr) {
    List<int> req = [];

    req.add(0x06); // ReadWithoutEncryptionのリクエストコード
    req.addAll(idm);
    req.add(0x01); // サービス数

    req.add(_serviceCode[0]); // サービスコードの下位バイト
    req.add(_serviceCode[1]); // サービスコードの上位バイト
    req.add(0x01); // 同時読み込みブロック数

    req.add(0x80); // ブロックエレメント上位バイト
    req.add(addr); // 0

    req.insert(0, req.length + 1);

    return Uint8List.fromList(req);
  }
}

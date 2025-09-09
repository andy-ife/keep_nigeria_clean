import 'package:firebase_database/firebase_database.dart';
import 'package:keep_nigeria_clean/constants/assets.dart';
import 'package:keep_nigeria_clean/constants/gases.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:keep_nigeria_clean/utils/helpers.dart';

class BinDataService {
  final _bin1Ref = FirebaseDatabase.instance
      .ref()
      .child('SmartBin1')
      .child('readings');

  final _bin2Ref = FirebaseDatabase.instance
      .ref()
      .child('SmartBin2')
      .child('readings');

  final _uploadIntervalRef = FirebaseDatabase.instance.ref().child(
    'upload_interval',
  );

  Stream<Reading?> bin1Stream() {
    return _bin1Ref.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      return data != null
          ? Reading.fromJson(data.cast<String, dynamic>())
          : null;
    });
  }

  Stream<Reading?> bin2Stream() {
    return _bin2Ref.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      return data != null
          ? Reading.fromJson(data.cast<String, dynamic>())
          : null;
    });
  }

  List<Gas> calculateGases(double gasPpm) {
    final gases = <Gas>[];

    if (gasPpm > 50 && gasPpm <= 200) {
      gases.addAll([
        GasConstants.alcohol.copyWith(
          level: Level.medium,
          lastUpdate: DateTime.now(),
        ),
        GasConstants.smoke.copyWith(
          level: Level.low,
          lastUpdate: DateTime.now(),
        ),
      ]);
    } else if (gasPpm > 200 && gasPpm <= 300) {
      gases.add(
        GasConstants.methane.copyWith(
          level: Level.high,
          lastUpdate: DateTime.now(),
        ),
      );
    } else if (gasPpm > 500) {
      gases.add(
        GasConstants.butane.copyWith(
          level: Level.high,
          lastUpdate: DateTime.now(),
        ),
      );
    }
    Helper.sortGasesByLevel(gases);
    return gases;
  }

  String calculateAssetPath(double fillLevel) {
    late String asset;
    if (fillLevel < 10) {
      asset = AssetConstants.bin0;
    } else if (fillLevel >= 10 && fillLevel < 25) {
      asset = AssetConstants.bin10;
    } else if (fillLevel >= 25 && fillLevel < 50) {
      asset = AssetConstants.bin25;
    } else if (fillLevel >= 50 && fillLevel < 75) {
      asset = AssetConstants.bin50;
    } else if (fillLevel >= 75 && fillLevel < 90) {
      asset = AssetConstants.bin75;
    } else if (fillLevel >= 90 && fillLevel < 100) {
      asset = AssetConstants.bin90;
    } else {
      asset = AssetConstants.bin100;
    }

    return asset;
  }

  Future<int> setUploadInterval(int frequency) async {
    await _uploadIntervalRef.set(frequency).timeout(Duration(seconds: 10));
    return frequency;
  }

  Future<int> getUploadInterval() async {
    final snapshot = await _uploadIntervalRef.get().timeout(
      Duration(seconds: 10),
    );
    return snapshot.value as int;
  }
}

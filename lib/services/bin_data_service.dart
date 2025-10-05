import 'package:keep_nigeria_clean/constants/gases.dart';
import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keep_nigeria_clean/services/realtime_bin_service.dart';
import 'package:rxdart/rxdart.dart';

class BinDataService {
  late RealtimeBinService _rtbinService;

  BinDataService() {
    _rtbinService = RealtimeBinService();
  }

  final bin1Stream = FirebaseFirestore.instance
      .collection('smartBins')
      .doc('SmartBin1')
      .collection('readings')
      .orderBy('timestamp')
      .snapshots()
      .map(
        (event) => event.docs.map((d) => Reading.fromJson(d.data())).toList(),
      );

  final bin2Stream = FirebaseFirestore.instance
      .collection('smartBins')
      .doc('SmartBin2')
      .collection('readings')
      .orderBy('timestamp')
      .snapshots()
      .map(
        (event) => event.docs.map((d) => Reading.fromJson(d.data())).toList(),
      );

  Stream<List<Reading>> get allStream => Rx.combineLatest2(
    bin1Stream,
    bin2Stream,
    (a, b) => [...a, ...b]
      ..sort(
        (a, b) =>
            DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)),
      ),
  );

  double getAvgFillLevel(List<Reading> readings) {
    if (readings.isEmpty) return 0.0;
    final total = readings.fold<double>(0.0, (cum, r) => cum + r.fillLevel);
    return total / readings.length;
  }

  double getAvgTemp(List<Reading> readings) {
    if (readings.isEmpty) return 0.0;
    final total = readings.fold<double>(0.0, (cum, r) => cum + r.temperature);
    return total / readings.length;
  }

  Map<Gas, int> countDetectedGases(List<Reading> readings) {
    final gasConstants = [
      GasConstants.methane,
      GasConstants.butane,
      GasConstants.alcohol,
      GasConstants.smoke,
    ];

    final Map<Gas, int> gasCounts = {for (var gc in gasConstants) gc: 0};

    for (final reading in readings) {
      final gases = _rtbinService.calculateGases(reading.gasPpm);
      for (final gas in gases) {
        final matched = gasConstants.firstWhere(
          (gc) => gc.name == gas.name,
          orElse: () => Gas(name: "null"),
        );
        if (matched.name != "null") {
          gasCounts[matched] = (gasCounts[matched] ?? 0) + 1;
        }
      }
    }
    return gasCounts;
  }

  // TODO: Implement this
  double getAIPrediction() => 100.0;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/models/gas.dart';
import 'package:keep_nigeria_clean/models/reading.dart';
import 'package:keep_nigeria_clean/services/bin_data_service.dart';

class AnalyticsController extends ChangeNotifier {
  final _service = BinDataService();

  StreamController<String>? _streamController;
  StreamSubscription? _subscription;

  final tabs = ['All', 'Bin A', 'Bin B'];

  AnalyticsState state = AnalyticsState();

  AnalyticsController() {
    refresh();
  }

  void refresh() {
    init();
    switchTimeframe('All');
  }

  void init() {
    if (state.loading) return;
    state = state.copyWith(loading: true, error: '');

    _streamController?.close();
    _streamController = StreamController<String>();

    _streamController?.stream.asBroadcastStream().listen((streamIndex) {
      _subscription?.cancel();

      Stream<List<Reading>> targetStream;
      switch (streamIndex) {
        case 'All':
          targetStream = _service.allStream;
          break;
        case 'Bin A':
          targetStream = _service.bin1Stream;
          break;
        case 'Bin B':
          targetStream = _service.bin2Stream;
          break;
        default:
          print('Invalid stream index: $streamIndex');
          return;
      }

      _subscription = targetStream.listen(
        (value) {
          final avgFill = _service.getAvgFillLevel(value);
          final avgTemp = _service.getAvgTemp(value);
          final gasCounts = _service.countDetectedGases(value);

          state = state.copyWith(
            loading: false,
            error: '',
            data: value,
            avgFillLevel: avgFill.round(),
            avgTemp: avgTemp.round(),
            gasCounts: gasCounts,
          );
          notifyListeners();
        },
        onError: (e) {
          state = state.copyWith(loading: false, error: e.toString());
          notifyListeners();
        },
      );
    });
  }

  void switchTimeframe(String tag) {
    _streamController?.add(tag);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _streamController?.close();
    super.dispose();
  }
}

class AnalyticsState {
  final bool loading;
  final String error;
  final List<Reading> data;
  final int avgFillLevel;
  final int avgTemp;
  final Map<Gas, int> gasCounts;

  const AnalyticsState({
    this.loading = false,
    this.error = '',
    this.data = const [],
    this.avgFillLevel = 0,
    this.avgTemp = 0,
    this.gasCounts = const {},
  });

  AnalyticsState copyWith({
    bool? loading,
    String? error,
    List<Reading>? data,
    int? avgFillLevel,
    int? avgTemp,
    Map<Gas, int>? gasCounts,
  }) => AnalyticsState(
    loading: loading ?? this.loading,
    error: error ?? this.error,
    data: data ?? this.data,
    avgFillLevel: avgFillLevel ?? this.avgFillLevel,
    avgTemp: avgTemp ?? this.avgTemp,
    gasCounts: gasCounts ?? this.gasCounts,
  );
}

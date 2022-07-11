import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/scan/reducer.dart';
import 'package:redux/redux.dart';

class Scan extends StatelessWidget {
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (store, viewmodel) {
        return ElevatedButton(onPressed: viewmodel.scanScanned, child: const Text('scan'));
      }
    );
  }
}
class _ViewModel {
  final VoidCallback scanScanned;
  _ViewModel({
    required this.scanScanned
  });
  factory _ViewModel.create(Store<AppState> store) {
    _scanScanned() async {
      final res = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      store.dispatch(ScanScanned(res));
    }
    return _ViewModel(
      scanScanned: _scanScanned
    );
  }
}
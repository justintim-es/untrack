import 'package:redux/redux.dart';

class ScanState {
  String scanned;
  ScanState({ required this.scanned });
  ScanState.initial():
    scanned = '';
  
  ScanState copyWith({
    String? scanned
  }) {
    return ScanState(
      scanned: scanned ?? this.scanned
    );
  }
}
class ScanAction {}
class ScanScanned extends ScanAction {
  String scanned;
  ScanScanned(this.scanned);
}
final scanReducer = combineReducers<ScanState>([
  TypedReducer<ScanState, ScanScanned>(_scanned)
]);
ScanState _scanned(ScanState state, ScanScanned action) {
  return state.copyWith(scanned: action.scanned);
}
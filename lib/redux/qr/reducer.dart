import 'package:redux/redux.dart';
class QrState {
	bool isQr;
	String id;
	String error;
	QrState({ required this.isQr, required this.id, required this.error });
	QrState.initial():
		isQr = false,
		id = '',
		error = '';
	QrState copyWith({
		bool? isQr,
		String? id,
		String? error
	}) {
		return QrState(
			isQr: isQr ?? this.isQr,
			id: id ?? this.id,
			error: error ?? this.error
		);
	}
}
class QrAction {}
class QrId extends QrAction {}
class QrIdSuccess extends QrAction {
	String id;
	QrIdSuccess(this.id);
}
class QrIdError extends QrAction {
	String error;
	QrIdError(this.error);
}

final qrReducer = combineReducers<QrState>([
	TypedReducer<QrState, QrId>(_qrId),
	TypedReducer<QrState, QrIdSuccess>(_qrIdSuccess),
	TypedReducer<QrState, QrIdError>(_qrIdError)
]);
QrState _qrId(QrState state, QrId action) {
	return state.copyWith(isQr: true, id: '');
}
QrState _qrIdSuccess(QrState state, QrIdSuccess action) {
	return state.copyWith(isQr: false, id: action.id);
}
QrState _qrIdError(QrState state, QrIdError action) {
	return state.copyWith(isQr: false, error: action.error);
}

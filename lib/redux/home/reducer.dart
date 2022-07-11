import 'package:frontend/redux/models.dart';
import 'package:redux/redux.dart';
class HomeState {
	bool isFetch;
	String fetchErrorMessage;
	List<OurMsg> incomings;
	List<OurMsg> outgoings;

	HomeState({
		required this.isFetch,
		required this.fetchErrorMessage,
		required this.incomings,
		required this.outgoings
	});
	HomeState.initial():
		isFetch = false, fetchErrorMessage = '', incomings = [], outgoings = [];
	HomeState copyWith({
		bool? isFetch,
		String? fetchErrorMessage,
		List<OurMsg>? incomings,
		List<OurMsg>? outgoings
	}) {
		return HomeState(
			isFetch: isFetch ?? this.isFetch,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage,
			incomings: incomings ?? this.incomings,
			outgoings: outgoings ?? this.outgoings
		);
	}
}
class HomeAction {}
class FetchHomeAction extends HomeAction {}
class FetchSuccessHomeAction extends HomeAction {
	List<OurMsg> outgoings;
	List<OurMsg> incomings;
	FetchSuccessHomeAction(this.outgoings, this.incomings);
}
class FetchErrorHomeAction extends HomeAction {
	String error;
	FetchErrorHomeAction(this.error);
}

final homeReducer = combineReducers<HomeState>([
	TypedReducer<HomeState, FetchHomeAction>(_fetch),
	TypedReducer<HomeState, FetchSuccessHomeAction>(_fetchSuccess),
	TypedReducer<HomeState, FetchErrorHomeAction>(_fetchError)
]);
HomeState _fetch(HomeState state, FetchHomeAction action) {
	return state.copyWith(isFetch: true);
}
HomeState _fetchSuccess(HomeState state, FetchSuccessHomeAction action) {
	return state.copyWith(isFetch: false, incomings: action.incomings, outgoings: action.outgoings);
}
HomeState _fetchError(HomeState state, FetchErrorHomeAction action) {
	return state.copyWith(isFetch: false, fetchErrorMessage: action.error);
}

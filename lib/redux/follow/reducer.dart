import 'package:redux/redux.dart';
class FollowState {
	bool isFetch;
	bool isFetchSuccess;
	bool isFetchError;
	String fetchErrorMessage;
	FollowState({ required this.isFetch, required this.isFetchSuccess, required this.isFetchError, required this.fetchErrorMessage});
	FollowState.initial():
		isFetch = false,
		isFetchSuccess = false,
		isFetchError = false,
		fetchErrorMessage = '';
	FollowState copyWith({
		bool? isFetch,
		bool? isFetchSuccess,
		bool? isFetchError,
		String? fetchErrorMessage
	}) {
		return FollowState(
			isFetch: isFetch ?? this.isFetch,
			isFetchSuccess: isFetchSuccess ?? this.isFetchSuccess,
			isFetchError: isFetchError ?? this.isFetchError,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage
		);
	}
}
class FollowAction {}
class FollowFetch extends FollowAction {
	String id;
	FollowFetch(this.id);
}
class FollowFetchSuccess extends FollowAction {}
class FollowFetchError extends FollowAction {
	String errorMessage;
	FollowFetchError(this.errorMessage);
}
final followReducer = combineReducers<FollowState>([
	TypedReducer<FollowState, FollowFetch>(_fetch),
	TypedReducer<FollowState, FollowFetchSuccess>(_fetchSuccess),
	TypedReducer<FollowState, FollowFetchError>(_fetchError),
]);
FollowState _fetch(FollowState state, FollowFetch action) {
	return state.copyWith(isFetch: true, isFetchSuccess: false, isFetchError: false, fetchErrorMessage: '');
}
FollowState _fetchSuccess(FollowState state, FollowFetchSuccess action) {
	return state.copyWith(isFetch: false, isFetchSuccess: true);
}
FollowState _fetchError(FollowState state, FollowFetchError action) {
	return state.copyWith(isFetch: false, isFetchError: true, fetchErrorMessage: action.errorMessage);
}

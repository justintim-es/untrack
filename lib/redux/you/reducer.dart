import 'package:redux/redux.dart';
import 'package:frontend/redux/combiner.dart';
class YouState {
	bool isFetch;
	bool isFetchError;
	List<Follower> followers;
	List<Follower> following;
	String fetchErrorMessage;
	YouState({ required this.isFetch, required this.isFetchError, required this.followers, required this.following, required this.fetchErrorMessage });
	YouState.initial():
		isFetch = false,
		isFetchError = false,
		followers = [],
		following = [],
		fetchErrorMessage = '';
	YouState copyWith({
		bool? isFetch,
		bool? isFetchError,
		List<Follower>? followers,
		List<Follower>? following,
		String? fetchErrorMessage
	}) {
		return YouState(
			isFetch: isFetch ?? this.isFetch,
			isFetchError: isFetchError ?? this.isFetchError,
			followers: followers ?? this.followers,
			following: following ?? this.following,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage
		);
	}
}
class YouAction {}
class FetchYou extends YouAction {}
class FetchSuccessYou extends YouAction {
	List<Follower> followers;
	List<Follower> following;
	FetchSuccessYou(this.followers, this.following);
}
class FetchErrorYou extends YouAction {
	String error;
	FetchErrorYou(this.error);
}
final youReducer = combineReducers<YouState>([
	TypedReducer<YouState, FetchYou>(_fetch),
	TypedReducer<YouState, FetchSuccessYou>(_fetchSuccess),
	TypedReducer<YouState, FetchErrorYou>(_fetchError)
]);
YouState _fetch(YouState state, FetchYou action) {
	return state.copyWith(isFetch: true);
}
YouState _fetchSuccess(YouState state, FetchSuccessYou action) {
	return state.copyWith(isFetch: false, followers: action.followers, following: action.following);
}
YouState _fetchError(YouState state, FetchErrorYou action) {
	return state.copyWith(isFetch: false, isFetchError: true, fetchErrorMessage: action.error);
}

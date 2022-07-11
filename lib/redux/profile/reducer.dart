import 'package:redux/redux.dart';
import 'package:frontend/redux/models.dart';
import 'dart:core';
class ProfileState {
	bool isFetch;
	List <ShowMsg> incoming;
	List<ShowMsg> outgoing;
	List<ProfileFollow> following;
	List<ProfileFollow> followers;
	ProfileState({
		required this.isFetch,
		required this.incoming,
		required this.outgoing,
		required this.following,
		required this.followers
	 });
	ProfileState.initial(): isFetch = false, incoming = [], outgoing = [], following = [], followers = [];
	ProfileState copyWith({
		bool? isFetch,
		List<ShowMsg>? incoming,
		List<ShowMsg>? outgoing,
		List<ProfileFollow>? following,
		List<ProfileFollow>? followers
	}) {
		return ProfileState(
			isFetch: isFetch ?? this.isFetch,
			incoming: incoming ?? this.incoming,
			outgoing: outgoing ?? this.outgoing,
			following: following ?? this.following,
			followers: followers ?? this.followers
		);
	}
}
class ProfileAction {}
class FetchProfileAction extends ProfileAction {
	String encryptedId;
	FetchProfileAction(this.encryptedId);
}
class FetchSuccessProfileAction extends ProfileAction {
	List<ShowMsg> incoming;
	List<ShowMsg> outgoing;
	List<ProfileFollow> following;
	List<ProfileFollow> followers;
	FetchSuccessProfileAction({ required this.incoming, required this.outgoing, required this.following, required this.followers });
}
class FetchErrorProfileAction extends ProfileAction {}

class RefreshAndNavigateProfileAction extends ProfileAction {
	String encryptedId;
	String nickname;
	RefreshAndNavigateProfileAction(this.encryptedId, this.nickname);
}

class RefreshAndNavigateOneProfileAction extends ProfileAction {
	String encryptedId;
	String nickname;
	RefreshAndNavigateOneProfileAction(this.encryptedId, this.nickname);
}
class BlockProfileAction extends ProfileAction {
	String encryptedId;
	BlockProfileAction(this.encryptedId);
}
class BlockSuccessProfileAction extends ProfileAction {}
class BlockErrorProfileAction extends ProfileAction {
	String error;
	BlockErrorProfileAction(this.error);
}
final profileReducer = combineReducers<ProfileState>([
	TypedReducer<ProfileState, FetchProfileAction>(_fetch),
	TypedReducer<ProfileState, FetchSuccessProfileAction>(_fetchSuccess),
	TypedReducer<ProfileState, BlockProfileAction>(_block),
	TypedReducer<ProfileState, BlockSuccessProfileAction>(_blockSuccess)
]);
ProfileState _fetch(ProfileState state, FetchProfileAction action) {
	return state.copyWith(isFetch: true);
}
ProfileState _fetchSuccess(ProfileState state, FetchSuccessProfileAction action) {
	return state.copyWith(
		isFetch: false,
		incoming: action.incoming,
		outgoing: action.outgoing,
		following: action.following,
		followers: action.followers
	);
}
ProfileState _block(ProfileState state, BlockProfileAction action) {
	return state.copyWith(
		isFetch: true
	);
}
ProfileState _blockSuccess(ProfileState state, BlockSuccessProfileAction action) {
	return state.copyWith(
		isFetch: false
	);
}

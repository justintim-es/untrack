import 'package:frontend/redux/models.dart';
import 'package:redux/redux.dart';
class ConversationsState {
	bool isFetch;
	List<List<OurMsg>> msgs;
	ConversationsState({ required this.isFetch, required this.msgs });
	ConversationsState.initial(): isFetch = false, msgs = [];
	ConversationsState copyWith({
		bool? isFetch,
		List<List<OurMsg>>? msgs
	}) {
		return ConversationsState(
			isFetch: isFetch ?? this.isFetch,
			msgs: msgs ?? this.msgs
		);
	}
}
class ConversationsAction {}
class FetchConversationsAction extends ConversationsAction {}
class FetchSuccessConversationsAction extends ConversationsAction {
	List<List<OurMsg>> msgs;
	FetchSuccessConversationsAction(this.msgs);
}
class FetchErrorConversationsAction extends ConversationsAction {
	String error;
	FetchErrorConversationsAction(this.error);
}
final conversationsReducer = combineReducers<ConversationsState>([
	TypedReducer<ConversationsState, FetchConversationsAction>(_fetch),
	TypedReducer<ConversationsState, FetchSuccessConversationsAction>(_fetchSuccess),
	TypedReducer<ConversationsState, FetchErrorConversationsAction>(_fetchError)
]);
ConversationsState _fetch(ConversationsState state, FetchConversationsAction action) {
	return state.copyWith(isFetch: true);
}
ConversationsState _fetchSuccess(ConversationsState state, FetchSuccessConversationsAction action) {
	return state.copyWith(isFetch: false, msgs: action.msgs);
}
ConversationsState _fetchError(ConversationsState state, FetchErrorConversationsAction action) {
	return state.copyWith(isFetch: false);
}

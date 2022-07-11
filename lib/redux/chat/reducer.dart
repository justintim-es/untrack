import 'package:redux/redux.dart';
import 'package:frontend/redux/models.dart';
class ChatState {
	bool isFetch;
	bool isFetchSuccess;
	bool isFetchError;
	bool isPrivate;
	String fetchErrorMessage;
	List<ChatMsg> text;
	ChatState({
		required this.isFetch,
		required this.isPrivate,
		required this.isFetchSuccess,
		required this.text,
		required this.isFetchError,
		required this.fetchErrorMessage });
	ChatState.initial():
		isFetch = false,
		isFetchSuccess = false,
		isFetchError = false,
		isPrivate = false,
		fetchErrorMessage = '',
		text = List<ChatMsg>.from([]);

	ChatState copyWith({
		bool? isFetch,
		bool? isFetchSuccess,
		bool? isPrivate,
		List<ChatMsg>? text,
		bool? isFetchError,
		String? fetchErrorMessage,
	}) {
		return ChatState(
			isFetch: isFetch ?? this.isFetch,
			isFetchSuccess: isFetchSuccess ?? this.isFetchSuccess,
			isPrivate: isPrivate ?? this.isPrivate,
			text: text ?? this.text,
			isFetchError: isFetchError ?? this.isFetchError,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage
		);
	}
}
class ChatAction {}
class FetchMessageChatAction extends ChatAction {
	String message;
	String to;
	FetchMessageChatAction(this.message, this.to);
}
class FetchSuccessMessageChatAction extends ChatAction {
	String to;
	FetchSuccessMessageChatAction(this.to);
}
class FetchErrorMessageChatAction extends ChatAction {
	String error;
	FetchErrorMessageChatAction(this.error);
}

class MessagesChatAction extends ChatAction {
	String to;
	MessagesChatAction(this.to);
}
class MessagesSuccessChatAction extends ChatAction {
	List<ChatMsg> txts;
	MessagesSuccessChatAction(this.txts);
}
class MessagesErrorChatAction extends ChatAction {
}
class SwitchChatAction extends ChatAction {
	bool isPrivate;
	SwitchChatAction(this.isPrivate);
}

final chatReducer = combineReducers<ChatState>([
	TypedReducer<ChatState, FetchMessageChatAction>(_fetchMessage),
	TypedReducer<ChatState, FetchSuccessMessageChatAction>(_fetchSuccessMessage),
	TypedReducer<ChatState, FetchErrorMessageChatAction>(_fetchErrorMessage),
	TypedReducer<ChatState, MessagesChatAction>(_messagesChat),
	TypedReducer<ChatState, MessagesSuccessChatAction>(_messagesSuccess),
	TypedReducer<ChatState, SwitchChatAction>(_switch)
]);
ChatState _fetchMessage(ChatState state, FetchMessageChatAction action) {
	return state.copyWith(isFetch: true, isFetchSuccess: false, isFetchError: false, fetchErrorMessage: '');
}
ChatState _fetchSuccessMessage(ChatState state, FetchSuccessMessageChatAction action) {
	return state.copyWith(isFetch: false, isFetchSuccess: true);
}
ChatState _fetchErrorMessage(ChatState state, FetchErrorMessageChatAction action) {
	return state.copyWith(isFetch: false, isFetchError: true, fetchErrorMessage: action.error);
}
ChatState _messagesChat(ChatState state, MessagesChatAction action) {
	return state.copyWith(isFetch: true);
}
ChatState _messagesSuccess(ChatState state, MessagesSuccessChatAction action) {
	return state.copyWith(isFetch: false, text: action.txts);
}
ChatState _switch(ChatState state, SwitchChatAction action) {
	return state.copyWith(isPrivate: action.isPrivate);
}

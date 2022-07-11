import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/chat/reducer.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:frontend/redux/models.dart';
Stream<dynamic> fetchMessageChatAction(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FetchMessageChatAction)
	.asyncMap((action) => Dio().post('${store.state.url.url}/chat', data: {
		'to': action.to,
		'message': action.message,
		'isPrivate': store.state.chat.isPrivate
	}, options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	})).then<dynamic>((res) => FetchSuccessMessageChatAction(action.to)).catchError((error) => FetchErrorMessageChatAction(error.response.data['error'])));
}
Stream<dynamic> fetchSuccessMessageChatAction(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FetchSuccessMessageChatAction)
	.map((action) => MessagesChatAction(action.to));
}
Stream<dynamic> messagesChatAction(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is MessagesChatAction)
	.asyncMap((action) => Dio().get('${store.state.url.url}/chat/${action.to}', options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	})).then<dynamic>(
	(res) => MessagesSuccessChatAction(List<ChatMsg>.from(json.decode(res.data).map((x) => ChatMsg.fromJson((x))))))
	.catchError((error) => MessagesErrorChatAction()));
}

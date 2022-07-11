import 'package:redux_epics/redux_epics.dart';
import 'dart:async';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/stream_msg/reducer.dart';
import 'package:frontend/redux/models.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:frontend/redux/error/reducer.dart';
import 'package:frontend/redux/stream/reducer.dart';

Stream<dynamic> setIncomingStreamAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is SetIncomingStreamMsgAction)
  .expand((action) =>
 	action.streamMsgs.map((x) => FetchLikesIncomingStreamMsgAction(x.msgId)).isNotEmpty ?
    action.streamMsgs.map((x) => FetchLikesIncomingStreamMsgAction(x.msgId)) :
    [StopFetchingStreamAction(true)]);
}
Stream<dynamic> setIncomingStreamActionOne(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is SetIncomingStreamMsgAction)
  .expand((action) =>
  action.streamMsgs.map((x) => FetchCommentsIncomingStreamMsgAction(x.msgId)).isNotEmpty ?
    action.streamMsgs.map((x) => FetchCommentsIncomingStreamMsgAction(x.msgId)) :
    [StopFetchingStreamAction(true)]);
}
Stream<dynamic> setOutgoingStreamAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is SetOutgoingStreamMsgAction)
  .expand((action) =>
  action.streamMsgs.map((x) => FetchLikesOutgoingStreamMsgAction(x.msgId)).isNotEmpty ?
  action.streamMsgs.map((x) => FetchLikesOutgoingStreamMsgAction(x.msgId)) :
	[StopFetchingStreamAction(false)]);
}
Stream<dynamic> setOutgoingStreamActionOne(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is SetIncomingStreamMsgAction)
  .expand((action) =>
  action.streamMsgs.map((x) => FetchCommentsOutgoingStreamMsgAction(x.msgId)).isNotEmpty ?
    action.streamMsgs.map((x) => FetchCommentsOutgoingStreamMsgAction(x.msgId)) :
    [StopFetchingStreamAction(true)]);
}
Stream<dynamic> fetchLikesIncomingStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikesIncomingStreamMsgAction)
  .asyncMap((action) => Dio().get('${store.state.url.url}/likes/${action.msgId}', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then((res) => FetchLikesSuccessIncomingStreamMsgAction(action.msgId, List<Like>.from(json.decode(res.data).map((x) => Like.fromJson(x)))))
  .catchError((error) => SetErrorAction(error.response.data['error'])));
}
Stream<dynamic> fetchLikesOutgoingStreamAction(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
  .where((action) => action is FetchLikesOutgoingStreamMsgAction)
	.asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/likes/${action.msgId}', options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	})).then((res) => FetchLikesSuccessOutgoingStreamMsgAction(action.msgId, List<Like>.from(json.decode(res.data).map((x) => Like.fromJson(x)))))
  .catchError((error) => SetErrorAction(error.response.data['error'])));
}
Stream<dynamic> fetchCommentsIncomingStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchCommentsIncomingStreamMsgAction)
  .asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/comments/${action.msgId}', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then((res) => FetchCommentsSuccessIncomingStreamMsgAction(action.msgId, List<Comment>.from(json.decode(res.data).map((x) => Comment.fromJson(x))))));
}
Stream<dynamic> fetchCommentsOutgoingStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchCommentsOutgoingStreamMsgAction)
  .asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/comments/${action.msgId}', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then((res) => FetchCommentsSuccessOutgoingStreamMsgAction(action.msgId, List<Comment>.from(json.decode(res.data).map((x) => Comment.fromJson(x))))));
}
Stream<dynamic> fetchLikesSuccessIncomingStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikesSuccessIncomingStreamMsgAction)
  .map((action) => StopFetchingStreamAction(true));
}
Stream<dynamic> fetchLikesSuccessOutgoingStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikesSuccessOutgoingStreamMsgAction)
  .map((action) => StopFetchingStreamAction(false));
}
Stream<dynamic> fetchLikeStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikeStreamMsgAction)
  .asyncMap<dynamic>((action) => Dio().post('${store.state.url.url}/likes/${action.msgId}', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then(
    (res) =>
    action.isIncoming ?
    FetchLikesIncomingStreamMsgAction(action.msgId) :
    FetchLikesOutgoingStreamMsgAction(action.msgId)
  ).catchError((error) => SetErrorAction(error.response.data['error'])));
}
Stream<dynamic> fetchCommentStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchCommentStreamMsgAction)
  .asyncMap<dynamic>((action) => Dio().post('${store.state.url.url}/comments', data: {
    'msgId': action.msgId,
    'value': action.value
  }, options: Options(headers: {
  	'x-api-key': store.state.login.accessToken
  })).then((res) => action.isIncoming ? FetchCommentsIncomingStreamMsgAction(action.msgId) : FetchCommentsOutgoingStreamMsgAction(action.msgId)));
}

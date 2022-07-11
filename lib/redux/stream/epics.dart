import 'package:redux_epics/redux_epics.dart';
import 'dart:async';
import 'package:frontend/redux/combiner.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:frontend/redux/models.dart';
import 'package:frontend/redux/stream_msg/reducer.dart';
import 'package:frontend/redux/stream/reducer.dart';
Stream<dynamic> fetchStreamAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchStreamAction)
  .asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/stream', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then<dynamic>((res) => FetchSuccessStreamMsgAction(res)).catchError((error) =>
		throw(error)));
}

Stream<dynamic> fetchSuccessStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchSuccessStreamMsgAction)
	.expand((action) => [
    SetIncomingStreamMsgAction(List<StreamMsg>.from(json.decode(action.response.data['incoming']).map((x) => StreamMsg.fromJson(x)))),
    SetOutgoingStreamMsgAction(List<StreamMsg>.from(json.decode(action.response.data['outgoing']).map((x) => StreamMsg.fromJson(x))))
  ]);
}
Stream<dynamic> fetchLikeStreamAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikeStreamAction)
  .asyncMap((action) => Dio().post('${store.state.url.url}/likes/${action.msgId}', options: Options(headers: {
    'x-api-key': store.state.login.accessToken
  })).then(
    (res) => action.isIncoming ?
    FetchLikesSuccessIncomingStreamMsgAction(action.msgId, List<Like>.from(json.decode(res.data).map((x) => Like.fromJson(x)))) :
    FetchLikesSuccessOutgoingStreamMsgAction(action.msgId, List<Like>.from(json.decode(res.data).map((x) => Like.fromJson(x))))));
}
Stream<dynamic> fetchLikesSuccessStreamMsgAction(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
  .where((action) => action is FetchLikesSuccessIncomingStreamMsgAction || action is FetchLikesOutgoingStreamMsgAction)
  .map((action) => StopFetchingStreamAction(action.isIncoming));
}

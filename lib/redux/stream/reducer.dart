import 'package:redux/redux.dart';
import 'package:frontend/redux/models.dart';
import 'dart:async';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
class StreamState {
    bool isIncomingFetch;
    bool isOutgoingFetch;
    String fetchErrorMessage;
    StreamState({
      required this.isIncomingFetch,
      required this.isOutgoingFetch,
      required this.fetchErrorMessage,
    });
    StreamState.initial():
      isIncomingFetch = false, isOutgoingFetch = false, fetchErrorMessage = '';
    StreamState copyWith({
      bool? isIncomingFetch,
      bool? isOutgoingFetch,
      String? fetchErrorMessage,
    }) {
      return StreamState(
        isIncomingFetch: isIncomingFetch ?? this.isIncomingFetch,
        isOutgoingFetch: isOutgoingFetch ?? this.isOutgoingFetch,
        fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage,
      );
    }
}
class StreamAction {}
class FetchStreamAction extends StreamAction {}

class FetchLikesStreamAction extends StreamAction {
	int msgId;
	FetchLikesStreamAction(this.msgId);
}
class FetchLikesSuccessStreamAction extends StreamAction {
  int msgId;
	List<Like> likes;
	FetchLikesSuccessStreamAction(this.msgId, this.likes);
}
class FetchLikesErrorStreamAction extends StreamAction {
  String error;
  FetchLikesErrorStreamAction(this.error);
}
class FetchErrorStreamAction extends StreamAction {
  dynamic error;
  FetchErrorStreamAction(this.error);
}
class FetchLikeStreamAction extends StreamAction {
  bool isIncoming;
  int msgId;
  FetchLikeStreamAction(this.isIncoming, this.msgId);
}
class StopFetchingStreamAction extends StreamAction {
  bool isIncoming;
  StopFetchingStreamAction(this.isIncoming);
}
final streamReducer = combineReducers<StreamState>([
  TypedReducer<StreamState, FetchStreamAction>(_fetch),
  TypedReducer<StreamState, FetchErrorStreamAction>(_fetchError),
  TypedReducer<StreamState, StopFetchingStreamAction>(_stopFetching)
]);
StreamState _fetch(StreamState state,  FetchStreamAction action) {
  return state.copyWith(isIncomingFetch: true, isOutgoingFetch: true);
}

StreamState _fetchError(StreamState state, FetchErrorStreamAction action) {
  return state.copyWith(isIncomingFetch: false, isOutgoingFetch: false, fetchErrorMessage: action.error);
}
StreamState _stopFetching(StreamState state, StopFetchingStreamAction action) {
	print(action.isIncoming);
  if(action.isIncoming) {
    return state.copyWith(isIncomingFetch: false);
  }else {
    return state.copyWith(isOutgoingFetch: false);
  }
}

  import 'package:redux/redux.dart';
import 'package:frontend/redux/models.dart';
import 'package:tuple/tuple.dart';
import 'package:dio/dio.dart';

class IncomingStreamAction {}
class OutgoingStreamAction {}


class SetStreamMsgAction {
  List<StreamMsg> streamMsgs;
  SetStreamMsgAction(this.streamMsgs);
}
class SetLikesStreamMsgAction {
  int msgId;
  List<Like> likes;
  SetLikesStreamMsgAction(this.msgId, this.likes);
}
class SetCommentsStreamMsgAction {
  int msgId;
  List<Comment> comments;
  SetCommentsStreamMsgAction(this.msgId, this.comments);
}
class SetIncomingStreamMsgAction extends SetStreamMsgAction with IncomingStreamAction {
  SetIncomingStreamMsgAction(List<StreamMsg> streamMsgs): super(streamMsgs);
}
class FetchLikesSuccessIncomingStreamMsgAction extends SetLikesStreamMsgAction with IncomingStreamAction {
  FetchLikesSuccessIncomingStreamMsgAction( int msgId, List<Like> likes): super(msgId, likes);
}
class SetOutgoingStreamMsgAction extends SetStreamMsgAction with OutgoingStreamAction {
  SetOutgoingStreamMsgAction(List<StreamMsg> streamMsgs): super(streamMsgs);
}
class FetchLikesSuccessOutgoingStreamMsgAction extends SetLikesStreamMsgAction with OutgoingStreamAction {
  FetchLikesSuccessOutgoingStreamMsgAction(int msgId, List<Like> likes): super(msgId, likes);
}
class FetchCommentsSuccessIncomingStreamMsgAction extends SetCommentsStreamMsgAction with IncomingStreamAction {
  FetchCommentsSuccessIncomingStreamMsgAction(int msgId, List<Comment> comments): super(msgId, comments);
}
class FetchCommentsSuccessOutgoingStreamMsgAction extends SetCommentsStreamMsgAction with OutgoingStreamAction {
  FetchCommentsSuccessOutgoingStreamMsgAction(int msgId, List<Comment> comments): super(msgId, comments);
}
class FetchSuccessStreamMsgAction {
  Response response;
  FetchSuccessStreamMsgAction(this.response);
}
class FetchLikesIncomingStreamMsgAction {
  int msgId;
  FetchLikesIncomingStreamMsgAction(this.msgId);
}
class FetchLikesOutgoingStreamMsgAction {
  int msgId;
  FetchLikesOutgoingStreamMsgAction(this.msgId);
}
class FetchCommentsIncomingStreamMsgAction {
  int msgId;
  FetchCommentsIncomingStreamMsgAction(this.msgId);
}
class FetchCommentsOutgoingStreamMsgAction {
  int msgId;
  FetchCommentsOutgoingStreamMsgAction(this.msgId);
}
class FetchLikeStreamMsgAction  {
  bool isIncoming;
  int msgId;
  FetchLikeStreamMsgAction(this.isIncoming, this.msgId);
}
class UnlikeStreamMsgAction {
  bool isIncoming;
  int msgId;
  UnlikeStreamMsgAction(this.isIncoming, this.msgId);
}
class FetchCommentStreamMsgAction {
  bool isIncoming;
  int msgId;
  String value;
  FetchCommentStreamMsgAction(this.isIncoming, this.msgId, this.value);
}


final streamMsgReducer = combineReducers<List<StreamMsg>>([
  TypedReducer<List<StreamMsg>, SetStreamMsgAction>(_set),
  TypedReducer<List<StreamMsg>, SetLikesStreamMsgAction>(_setLikes),
  TypedReducer<List<StreamMsg>, SetCommentsStreamMsgAction>(_setComments)
]);
List<StreamMsg> _set(List<StreamMsg> state, SetStreamMsgAction action) {
  return action.streamMsgs;
}
List<StreamMsg> _setLikes(List<StreamMsg> state, SetLikesStreamMsgAction action) {
  return state.map((x) => x.msgId == action.msgId ? x.copyWith(likes: action.likes) : x).toList();
}
List<StreamMsg> _setComments(List<StreamMsg> state, SetCommentsStreamMsgAction action) {
  return state.map((x) => x.msgId == action.msgId ? x.copyWith(comments: action.comments) : x).toList();
}

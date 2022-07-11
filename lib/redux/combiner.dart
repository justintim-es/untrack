import 'package:frontend/redux/scan/reducer.dart';
import 'package:redux/redux.dart';
import 'package:frontend/redux/register/reducer.dart';
import 'package:frontend/redux/login/reducer.dart';
import 'package:frontend/redux/follow/reducer.dart';
import 'package:frontend/redux/qr/reducer.dart';
import 'package:frontend/redux/url/reducer.dart';
import 'package:frontend/redux/bottom_nav/reducer.dart';
import 'package:frontend/redux/you/reducer.dart';
import 'package:frontend/redux/chat/reducer.dart';
import 'package:frontend/redux/profile/reducer.dart';
import 'package:frontend/redux/home/reducer.dart';
import 'package:frontend/redux/conversations/reducer.dart';
import 'package:frontend/redux/stream/reducer.dart';
import 'package:frontend/redux/models.dart';
import 'package:frontend/redux/stream_msg/reducer.dart';
import 'package:frontend/redux/error/reducer.dart';
class AppState {
	final RegisterState register;
	final LoginState login;
	final FollowState follow;
	final QrState qr;
	final UrlState url;
	final BottomNavState bottomNav;
	final YouState you;
	final ChatState chat;
	final ProfileState profile;
	final HomeState home;
	final StreamState stream;
	final ConversationsState conversations;
	final List<StreamMsg> incomingStreamMsgs;
	final List<StreamMsg> outgoingStreamMsgs;
	final ErrorState error;
  final ScanState scan;
	AppState({
		required this.register,
		required this.login,
		required this.follow,
		required this.qr,
		required this.url,
		required this.bottomNav,
		required this.you,
		required this.chat,
		required this.profile,
		required this.home,
		required this.conversations,
		required this.stream,
		required this.incomingStreamMsgs,
		required this.outgoingStreamMsgs,
		required this.error,
    required this.scan
	});
	AppState.initial():
		register = RegisterState.initial(),
		login = LoginState.initial(),
		follow = FollowState.initial(),
		qr = QrState.initial(),
		url = UrlState.initial(),
		bottomNav = BottomNavState.initial(),
		you = YouState.initial(),
		chat = ChatState.initial(),
		profile = ProfileState.initial(),
		home = HomeState.initial(),
		conversations = ConversationsState.initial(),
		stream = StreamState.initial(),
		incomingStreamMsgs = [],
		outgoingStreamMsgs = [],
		error = ErrorState.initial(),
    scan = ScanState.initial();
	AppState copyWith({
		RegisterState? register,
		LoginState? login,
		FollowState? follow,
		QrState? qr,
		UrlState? url,
		BottomNavState? bottomNav,
		YouState? you,
		ChatState? chat,
		ProfileState? profile,
		HomeState? home,
		ConversationsState? conversations,
		StreamState? stream,
		List<StreamMsg>? incomingStreamMsgs,
		List<StreamMsg>? outgoingStreamMsgs,
		ErrorState? error,
    ScanState? scan
	}) {
		return AppState(
			register: register ?? this.register,
			login: login ?? this.login,
			follow: follow ?? this.follow,
			qr: qr ?? this.qr,
			url: url ?? this.url,
			bottomNav: bottomNav ?? this.bottomNav,
			you: you ?? this.you,
			chat: chat ?? this.chat,
			profile: profile ?? this.profile,
			home: home ?? this.home,
			conversations: conversations ?? this.conversations,
			stream: stream ?? this.stream,
			incomingStreamMsgs: incomingStreamMsgs ?? this.incomingStreamMsgs,
			outgoingStreamMsgs: outgoingStreamMsgs ?? this.outgoingStreamMsgs,
			error: error ?? this.error,
      scan: scan ?? this.scan
		);
	}
}
final appReducer = combineReducers<AppState>([
	TypedReducer<AppState, RegisterAction>(_register),
	TypedReducer<AppState, LoginAction>(_login),
	TypedReducer<AppState, FollowAction>(_follow),
	TypedReducer<AppState, QrAction>(_qr),
	TypedReducer<AppState, UrlAction>(_url),
	TypedReducer<AppState, BottomNavAction>(_bottomNav),
	TypedReducer<AppState, YouAction>(_you),
	TypedReducer<AppState, ChatAction>(_chat),
	TypedReducer<AppState, ProfileAction>(_profile),
	TypedReducer<AppState, HomeAction>(_home),
	TypedReducer<AppState, ConversationsAction>(_conversations),
	TypedReducer<AppState, StreamAction>(_stream),
	TypedReducer<AppState, OutgoingStreamAction>(_outgoingStreamMsg),
	TypedReducer<AppState, IncomingStreamAction>(_incomingStreamMsg),
	TypedReducer<AppState, ErrorAction>(_error),
  TypedReducer<AppState, ScanAction>(_scan)
]);
AppState _register(AppState state, RegisterAction action) {
	return state.copyWith(register: registerReducer(state.register, action));
}
AppState _login(AppState state, LoginAction action) {
	return state.copyWith(login: loginReducer(state.login, action));
}
AppState _follow(AppState state, FollowAction action) {
	return state.copyWith(follow: followReducer(state.follow, action));
}
AppState _qr(AppState state, QrAction action) {
	return state.copyWith(qr: qrReducer(state.qr, action));
}
AppState _url(AppState state, UrlAction action) {
	return state.copyWith(url: urlReducer(state.url, action));
}
AppState _bottomNav(AppState state, BottomNavAction action) {
	return state.copyWith(bottomNav: bottomNavReducer(state.bottomNav, action));
}
AppState _you(AppState state, YouAction action) {
	return state.copyWith(you: youReducer(state.you, action));
}
AppState _chat(AppState state, ChatAction action) {
	return state.copyWith(chat: chatReducer(state.chat, action));
}
AppState _profile(AppState state, ProfileAction action) {
	return state.copyWith(profile: profileReducer(state.profile, action));
}
AppState _home(AppState state, HomeAction action) {
	return state.copyWith(home: homeReducer(state.home, action));
}
AppState _conversations(AppState state, ConversationsAction action) {
	return state.copyWith(conversations: conversationsReducer(state.conversations, action));
}
AppState _stream(AppState state, StreamAction action) {
	return state.copyWith(stream: streamReducer(state.stream, action));
}
AppState _incomingStreamMsg(AppState state, IncomingStreamAction action) {
	return state.copyWith(incomingStreamMsgs: streamMsgReducer(state.incomingStreamMsgs, action));
}
AppState _outgoingStreamMsg(AppState state, OutgoingStreamAction action) {
	return state.copyWith(outgoingStreamMsgs: streamMsgReducer(state.outgoingStreamMsgs, action));
}
AppState _error(AppState state, ErrorAction action) {
	return state.copyWith(error: errorReducer(state.error, action));
}
AppState _scan(AppState state, ScanAction action) {
  return state.copyWith(scan: scanReducer(state.scan, action));
}
class Follower {
	String nickname;
	String encryptedId;
	int? followers;
	int? following;
	Follower({
		required this.nickname,
		required this.encryptedId,
		this.followers,
		this.following
	});
	Follower.fromJson(Map<String, dynamic> jsoschon):
		nickname = jsoschon['nickname'],
		encryptedId = jsoschon['encryptedId'],
		followers = jsoschon['followers'],
		following = jsoschon['following'];
}

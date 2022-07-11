import 'package:redux_epics/redux_epics.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/you/reducer.dart';
import 'dart:convert';
Stream<dynamic> fetchYou(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FetchYou)
	.asyncMap<dynamic>((action) => Future.wait([
		Dio().get('${store.state.url.url}/following/${store.state.qr.id}', options: Options(headers: {
			'x-api-key': store.state.login.accessToken
		})),
		Dio().get('${store.state.url.url}/following', options: Options(headers: {
			'x-api-key': store.state.login.accessToken
		}))
	]).then<dynamic>(
	(res) => FetchSuccessYou(
	List<Follower>.from(json.decode(res[0].data).map((f) => Follower.fromJson(f))),
	List<Follower>.from(json.decode(res[1].data).map((f) => Follower.fromJson(f)))
	))
	.catchError((error) { print(error); FetchErrorYou(error.response['error']); }));
}

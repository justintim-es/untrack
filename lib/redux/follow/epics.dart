import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/follow/reducer.dart';
import 'package:dio/dio.dart';
import 'dart:async';
Stream<dynamic> followFetch(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FollowFetch)
	.asyncMap<dynamic>((action) => Dio().post('${store.state.url.url}/following/${action.id}', options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	}))
	.then<dynamic>((res) => FollowFetchSuccess())
	.catchError((error) => FollowFetchError(error.response['error'])));
}

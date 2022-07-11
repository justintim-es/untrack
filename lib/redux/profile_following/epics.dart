import 'package:redux_epics/redux_epics.dart';
import 'dart:async';
import 'package:frontend/redux/combiner.dart';
import 'package:dio/dio.dart';

Stream<dynamic> routeToProfileFollowing(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is RouteToProfileFollowing)
	.map((action) => NavigateToAction.replace("/profile_following"))
}
Stream<dynamic> fetchProfileFollowing(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FetchProfileFollowing)
	.asyncMap((action) => Future.wait([
		Dio().get('${store.state.url.url}/profile-following/${store.state.profileFollowing.encryptedId}')
		Dio().get('${store.state.url.url}/profile-followers/${store.state.profileFollowing.encryptedId}')
	]).then<dynamic>((res) => ))
}

import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:dio/dio.dart';
import 'package:frontend/redux/register/reducer.dart';
import 'dart:async';
import 'package:frontend/redux/combiner.dart';
Stream<dynamic> register(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
		.where((action) => action is RegisterFetch)
		.asyncMap<dynamic>((action) => Dio().post('${store.state.url.url}/register', data: {
			'username': action.email,
			'nickname': action.username,
			'password': action.password
		}).then<dynamic>((res) => RegisterFetchSuccess()).catchError((error) => RegisterFetchError(error.response.data['error'])));
}

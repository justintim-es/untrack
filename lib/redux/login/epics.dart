import 'package:dio/dio.dart';
import 'package:frontend/redux/login/reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/login/reducer.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:frontend/redux/qr/reducer.dart';
import 'package:frontend/redux/you/reducer.dart';

Stream<dynamic> login(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is LoginFetch)
	.asyncMap<dynamic>((action) => Dio().post('${store.state.url.url}/login', data: action.toJson())
	.then<dynamic>((res) => LoginFetchSuccess(res.data)).catchError((error) => LoginFetchError(error.response.data['error'])));
}
Stream<dynamic> loginFetchSuccess(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is LoginFetchSuccess)
	.map((action) => NavigateToAction.replace('/home'));
}
Stream<dynamic> loginFetchSuccessTwo(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is LoginFetchSuccess)
	.map((action) => QrId());
}

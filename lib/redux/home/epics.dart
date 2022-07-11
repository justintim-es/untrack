import 'package:redux_epics/redux_epics.dart';
import 'dart:async';
import 'package:frontend/redux/home/reducer.dart';
import 'package:dio/dio.dart';
import 'package:frontend/redux/models.dart';
import 'dart:convert';
import 'package:frontend/redux/combiner.dart';
Stream<dynamic> fetchHomeAction(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is FetchHomeAction)
	.asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/profile', options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	})).then((res) => FetchSuccessHomeAction(
		List<OurMsg>.from(json.decode(res.data['outgoing']).map((x) => OurMsg.fromJson(x))),
		List<OurMsg>.from(json.decode(res.data['incoming']).map((x) => OurMsg.fromJson(x))),
	)).catchError((error) => FetchErrorHomeAction(error.response['error'])));
}

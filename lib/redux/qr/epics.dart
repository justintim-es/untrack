import 'package:dio/dio.dart';
import 'package:frontend/redux/qr/reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/you/reducer.dart';
Stream<dynamic> qrId(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions.
	where((action) => action is QrId)
	.asyncMap<dynamic>((action) => Dio().get('${store.state.url.url}/chatter', options: Options(headers: {
		'x-api-key': store.state.login.accessToken
	})).then<dynamic>((res) => QrIdSuccess(res.data['id'])).catchError((error) => QrIdError(error.response['error'])));
}
Stream<dynamic> qrIdSuccess(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is QrIdSuccess)
	.map((action) => FetchYou());
}

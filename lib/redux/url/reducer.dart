import 'package:redux/redux.dart';
class UrlState {
	String? url;
	UrlState({ required this.url });
	UrlState.initial(): url = 'http://backend.untrackabl.es';
}
class UrlAction {}
final urlReducer = combineReducers<UrlState>([]);

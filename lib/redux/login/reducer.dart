import 'package:redux/redux.dart';
import 'dart:convert';
import 'package:flutter_redux/flutter_redux.dart';
class LoginState {
	bool isFetch;
	bool isFetchSuccess;
	bool isFetchError;
	String fetchErrorMessage;
	String accessToken;
	LoginState({ required this.isFetch, required this.isFetchSuccess, required this.isFetchError, required this.fetchErrorMessage, required this.accessToken });
	LoginState.initial():
		isFetch = false,
		isFetchSuccess = false,
		isFetchError = false,
		fetchErrorMessage = '',
		accessToken = '';

	LoginState copyWith({
		bool? isFetch,
		bool? isFetchSuccess,
		bool? isFetchError,
		String? fetchErrorMessage,
		String? accessToken
	}) {
		return LoginState(
			isFetch: isFetch ?? this.isFetch,
			isFetchSuccess: isFetchSuccess ?? this.isFetchSuccess,
			isFetchError: isFetchError ?? this.isFetchError,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage,
			accessToken: accessToken ?? this.accessToken
		);
	}
}
class LoginAction {}
class LoginFetch extends LoginAction {
	String email;
	String password;
	LoginFetch(this.email, this.password);
	Map<String, dynamic> toJson() => {
		'email': email,
		'password': password
	};
}
class LoginFetchSuccess extends LoginAction {
	String accessToken;
	LoginFetchSuccess(this.accessToken);
}
class LoginFetchError extends LoginAction {
	String errorMessage;
	LoginFetchError(this.errorMessage);
}
final loginReducer = combineReducers<LoginState>([
	TypedReducer<LoginState, LoginFetch>(_fetch),
	TypedReducer<LoginState, LoginFetchSuccess>(_fetchSuccess),
	TypedReducer<LoginState, LoginFetchError>(_fetchError),
]);
LoginState _fetch(LoginState state, LoginFetch action) {
	return state.copyWith(isFetch: true, isFetchSuccess: false, isFetchError: false, fetchErrorMessage: '', accessToken: '');
}
LoginState _fetchSuccess(LoginState state, LoginFetchSuccess action) {
	return state.copyWith(isFetch: false, isFetchSuccess: true, accessToken: action.accessToken);
}
LoginState _fetchError(LoginState state, LoginFetchError action) {
	return state.copyWith(isFetch: false, isFetchError: true, fetchErrorMessage: action.errorMessage);
}

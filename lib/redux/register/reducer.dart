import 'package:redux/redux.dart';
class RegisterState {
	final bool isFetch;
	final bool isFetchSuccess;
	final bool isFetchError;
	final String fetchErrorMessage;
	final bool isPasswordError;
	RegisterState({ required this.isFetch, required this.isFetchSuccess, required this.isFetchError, required this.fetchErrorMessage, required this.isPasswordError });
	RegisterState.initial():
		isFetch = false,
		isFetchSuccess = false,
		isFetchError = false,
		fetchErrorMessage = '',
		isPasswordError = false;

	RegisterState copyWith({
		bool? isFetch,
		bool? isFetchSuccess,
		bool? isFetchError,
		String? fetchErrorMessage,
		bool? isPasswordError,
	}) {
		return RegisterState(
			isFetch: isFetch ?? this.isFetch,
			isFetchSuccess: isFetchSuccess ?? this.isFetchSuccess,
			isFetchError: isFetchError ?? this.isFetchError,
			fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage,
			isPasswordError: isPasswordError ?? this.isPasswordError
		);
	}
}
class RegisterAction {}
class RegisterFetch extends RegisterAction {
	final String email;
	final String username;
	final String password;
	RegisterFetch(this.email, this.username, this.password);
}
class RegisterFetchSuccess extends RegisterAction {}
class RegisterFetchError extends RegisterAction {
	final dynamic fetchErrorMessage;
	RegisterFetchError(this.fetchErrorMessage);
}
class RegisterSnackbar extends RegisterAction {}
final registerReducer = combineReducers<RegisterState>([
	TypedReducer<RegisterState, RegisterFetch>(_fetch),
	TypedReducer<RegisterState, RegisterFetchSuccess>(_fetchSuccess),
	TypedReducer<RegisterState, RegisterFetchError>(_fetchError),
]);

RegisterState _fetch(RegisterState register, RegisterFetch action) {
	return register.copyWith(isFetch: true, isFetchSuccess: false, isFetchError: false, fetchErrorMessage: '');
}
RegisterState _fetchSuccess(RegisterState register, RegisterFetchSuccess action) {
	return register.copyWith(isFetch: false, isFetchSuccess: true);
}
RegisterState _fetchError(RegisterState register, RegisterFetchError action) {
	if(action.fetchErrorMessage.contains('password')) {
		return register.copyWith(isFetch: false, isFetchError: true, isPasswordError: true, fetchErrorMessage: action.fetchErrorMessage);
	}
	return register.copyWith(isFetch: false, isFetchError: true, fetchErrorMessage: action.fetchErrorMessage);
}

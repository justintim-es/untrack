import 'package:redux/redux.dart';

class ErrorState {
  bool isError;
  String error;
  ErrorState({ required this.isError, required this.error });
  ErrorState.initial():
    isError = false,
    error = '';
  ErrorState copyWith({
    bool? isError,
    String? error
  }) {
    return ErrorState(
      isError: isError ?? this.isError,
      error: error ?? this.error
    );
  }
}
class ErrorAction {}
class SetErrorAction {
  String error;
  SetErrorAction(this.error);
}
class ResetErrorAction {}

final errorReducer = combineReducers<ErrorState>([
    TypedReducer<ErrorState, SetErrorAction>(_set),
    TypedReducer<ErrorState, ResetErrorAction>(_reset)
]);
ErrorState _set(ErrorState state, SetErrorAction action) {
  return state.copyWith(isError: true, error: action.error);
}
ErrorState _reset(ErrorState state, ResetErrorAction action) {
  return state.copyWith(isError: false, error: '');
}

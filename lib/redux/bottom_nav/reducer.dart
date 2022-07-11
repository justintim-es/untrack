import 'package:redux/redux.dart';
class BottomNavState {
	int selected;
	BottomNavState({ required this.selected });
	BottomNavState.initial(): selected = 0;
	BottomNavState copyWith({
		int? selected
	}) {
		return BottomNavState(
			selected: selected ?? this.selected
		);
	}
}
class BottomNavAction {}
class BottomNavIndex extends BottomNavAction {
	int index;
	BottomNavIndex(this.index);
}
final bottomNavReducer = combineReducers<BottomNavState>([
	TypedReducer<BottomNavState, BottomNavIndex>(_index),
]);
BottomNavState _index(BottomNavState state, BottomNavIndex action) {
	print('gothere');
	return state.copyWith(selected: action.index);
}

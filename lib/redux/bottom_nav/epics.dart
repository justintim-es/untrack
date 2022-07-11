import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/bottom_nav/reducer.dart';
import 'package:frontend/redux/stream/reducer.dart';
Stream<dynamic> bottomNavIndex(Stream<dynamic> actions, EpicStore<AppState> store) {
	return actions
	.where((action) => action is BottomNavIndex)
	.expand((action)  => [
			FetchStreamAction()
		]
	);
}

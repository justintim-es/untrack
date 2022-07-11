import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:frontend/redux/combiner.dart';

class Dummy extends StatelessWidget {
	
	Widget build(BuildContext context) {
		final args = ModalRoute.of(context)!.settings.arguments as Follower;
		return StoreConnector<AppState, VoidCallback>(
			converter: (store) {
				return () => store.dispatch(NavigateToAction.replace('/chatter'));
			},
			builder: (context, state) {
				return Scaffold(
					backgroundColor: Colors.black
				);
			}, 
			//store.dispatch(NavigateToAction.replace('/chatter', arguments: args))
		);
	}
}

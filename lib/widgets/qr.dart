import 'package:flutter/material.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/qr/reducer.dart';
class Qr extends StatelessWidget {
	Widget build(BuildContext context) {
		return Stack(children: <Widget>[
			HighWay(),
			Scaffold(
				appBar: AppBar(title: Text('(un)trackabl.es', style: TextStyle(color: Colors.yellow)), backgroundColor: Colors.black54, actions: <Widget>[
					StoreConnector<AppState, VoidCallback>(
						converter: (store) {
							return () => store.dispatch(NavigateToAction.replace('/follow'));
						},
						builder: (context, callback) {
							return IconButton(icon: Icon(Icons.add), color: Colors.yellow, onPressed: callback);
						}
					)
				]),
				backgroundColor: Colors.black54,
				body: StoreConnector<AppState, QrState>(
								converter: (store) => store.state.qr,
								builder: (context, state) {
									return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
                    Image.network('http://qrcode.howtohackbitcoin.com/qrcode/${state.id}')  
                  ]);
								}
							),
				floatingActionButton: StoreConnector<AppState, VoidCallback>(
					converter: (store) {
						return () => store.dispatch(NavigateToAction.replace('/home'));
					},
					builder: (context, callback) {
						return Padding(
							padding: EdgeInsets.all(16.0),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: <Widget>[
									FloatingActionButton(
										onPressed: callback,
										child: Icon(Icons.home),
										backgroundColor: Colors.yellow
									),
									FloatingActionButton(
										onPressed: callback,
										child: Icon(Icons.change_circle),
										backgroundColor: Colors.yellow,
									)
								]
							)
						);
					}
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
			)
		]);
	}
}

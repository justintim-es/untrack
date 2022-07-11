import 'package:flutter/material.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:frontend/widgets/helpers/border.dart';
import 'package:frontend/widgets/typer.dart';
import 'package:frontend/redux/login/reducer.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
class Login extends StatelessWidget {
	final _emailController = TextEditingController();
	final _passwordController = TextEditingController();
	Widget build(BuildContext context) {
		return StoreConnector<AppState, LoginState>(
			converter: (store) => store.state.login,
			builder: (context, state) {
				if(state.isFetch || state.isFetchSuccess) {
					return Stack(children: <Widget>[
						HighWay(),
						LinearProgressIndicator()
					]);
				} else {
					return Stack(children: <Widget>[
						HighWay(),
						Scaffold(
							appBar: AppBar(title: Text('(un)trackabl.es', style: TextStyle(color: Colors.yellow)), backgroundColor: Colors.transparent),
							backgroundColor: Colors.black54,
							body: Padding(padding: EdgeInsets.only(left: 40, right: 40), child: Column(children: <Widget>[
								 Typer(),
							     SizedBox(height: 160),
							     TextField(
						         	cursorColor: Colors.yellow,
						         	style: const TextStyle(color: Colors.yellow),
						         	obscureText: false,
						         	decoration: InputDecoration(
							        	 labelText: 'E-mail',
							         	labelStyle: const TextStyle(color: Colors.yellow),
							         	border: const OutlineInputBorder(),
							         	enabledBorder: border(),
							         	focusedBorder: border(),
						        	),
					        		controller: _emailController,
						      	),
						      	SizedBox(height: 40),
						      	TextField(
						         	cursorColor: Colors.yellow,
						         	style: const TextStyle(color: Colors.yellow),
					     	    	obscureText: true,
			 				        decoration: InputDecoration(
						        		labelText: 'Password',
			 					        labelStyle: const TextStyle(color: Colors.yellow),
			 				         	border: const OutlineInputBorder(),
			      			         	enabledBorder: border(),
			    			        	focusedBorder: border(),
			   				       	),
			     	        		controller: _passwordController,
						      	),
						      	SizedBox(height: 40),
						      	StoreConnector<AppState, VoidCallback>(
						      		converter: (store) {
						      			return () => store.dispatch(LoginFetch(_emailController.text, _passwordController.text));
						      		},
						      		builder: (context, callback) {
						      			return ElevatedButton(child: Text('login'), onPressed: callback, style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)));
						      		}
						      	)
							]))
						)
					]);
				}
			},
			onWillChange: (old, neschew) {
				if(neschew.isFetchError) {
					var snackbar = SnackBar(
						content: Text('${neschew.fetchErrorMessage}', style: TextStyle(color: Colors.yellow)),
						backgroundColor: Colors.black
					);
					ScaffoldMessenger.of(context).showSnackBar(snackbar);
				}
			}
		);
	}
}

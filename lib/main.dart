import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:frontend/widgets/typer.dart';
import 'package:frontend/widgets/helpers/border.dart';
import 'package:frontend/widgets/login.dart';
import 'package:frontend/redux/register/reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:frontend/redux/register/epics.dart';
import 'package:frontend/redux/login/epics.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:frontend/widgets/home.dart';
import 'package:frontend/widgets/qr.dart';
import 'package:frontend/widgets/follow.dart';
import 'package:frontend/redux/qr/epics.dart';
import 'package:frontend/redux/follow/epics.dart';
import 'package:frontend/redux/you/epics.dart';
import 'package:frontend/widgets/profile_following.dart';
import 'package:frontend/widgets/chatter.dart';
import 'package:frontend/widgets/chat.dart';
import 'package:frontend/redux/chat/epics.dart';
import 'package:frontend/redux/profile/epics.dart';
import 'package:frontend/widgets/dummy.dart';
import 'package:frontend/redux/home/epics.dart';
import 'package:frontend/redux/conversations/epics.dart';
import 'package:frontend/redux/stream/epics.dart';
import 'package:frontend/redux/bottom_nav/epics.dart';
import 'package:frontend/redux/stream_msg/epics.dart';
import 'package:redux_remote_devtools/redux_remote_devtools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gAds;
final eschep = combineEpics<AppState>([
	register,
	login,
	loginFetchSuccess,
	loginFetchSuccessTwo,
	qrId,
	qrIdSuccess,
	followFetch,
	fetchYou,
	fetchMessageChatAction,
	fetchSuccessMessageChatAction,
	messagesChatAction,
	fetchProfileAction,
	refreshAndNavigateProfileAction,
	refreshAndNavigateOnePofileAction2,
	refreshAndNavigateOneProfileAction,
	fetchHomeAction,
	fetchConversationsAction,
	fetchStreamAction,
	fetchSuccessStreamMsgAction,
	bottomNavIndex,
	setIncomingStreamAction,
	setIncomingStreamActionOne,
	setOutgoingStreamAction,
	setOutgoingStreamActionOne,
	fetchLikesIncomingStreamMsgAction,
	fetchLikesOutgoingStreamAction,
	fetchCommentsOutgoingStreamMsgAction,
	fetchCommentsIncomingStreamMsgAction,
	fetchLikesSuccessIncomingStreamMsgAction,
	fetchLikesSuccessOutgoingStreamMsgAction,
	blockProfileAction,
	fetchLikeStreamMsgAction,
	fetchCommentStreamMsgAction
]);
var epicMiddleware = EpicMiddleware(eschep);
final store = DevToolsStore<AppState>(combineReducers<AppState>([appReducer]), initialState: AppState.initial(), middleware: [epicMiddleware, NavigationMiddleware(), LoggingMiddleware.printer()]);

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	gAds.MobileAds.instance.initialize();
	runApp(MyApp());
}


class MyApp extends StatelessWidget {
	Widget build(BuildContext) {
		return StoreProvider<AppState>(
			store: store,
			child: MaterialApp(
      				title: 'Flutter Demo',
      				theme: ThemeData(
        				primarySwatch: Colors.yellow,
        				brightness: Brightness.dark,
        				tabBarTheme: TabBarTheme(
									labelColor: Colors.yellow,
								),
        				iconTheme: IconThemeData(
        					color: Colors.yellow
        				)
      				),
      				navigatorKey: NavigatorHolder.navigatorKey,
      				routes: {
      					'/': (ctx) => Register(),
      					'/login': (ctx) => Login(),
      					'/home': (ctx) => Home(),
      					'/follow': (ctx) => Follow(),
      					'/qr': (ctx) => Qr(),
      					'/profile_following': (ctx) => ProfileFollowing(),
      					'/chatter': (ctx) => Chatter(),
      					'/chat': (ctx) => Chat(),
      					'/dummy': (ctx) => Dummy(),
                // '/scan': (ctx) => Scan(),
      				}
    	));
	}
}
class Register extends StatelessWidget {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Widget> foschorm(BuildContext context, RegisterState state) {
    return [
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
      obscureText: false,
      decoration: InputDecoration(
      labelText: 'Username',
      labelStyle: const TextStyle(color: Colors.yellow),
      border: const OutlineInputBorder(),
      enabledBorder: border(),
      focusedBorder: border()
      ),
      controller: _usernameController,
      ),
      SizedBox(height: 40),
      TextField(
      cursorColor: Colors.yellow,
      obscureText: true,
      decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: const TextStyle(color: Colors.yellow),
      border: const OutlineInputBorder(),
      enabledBorder: border(),
      focusedBorder: border()
      ),
      controller: _passwordController,
      ),
      SizedBox(height: 40),
    ];
  }


  @override
  Widget build(BuildContext context) {
  	return StoreConnector<AppState, RegisterState>(
  		converter: (store) => store.state.register,
  		builder: (context, state) {
  			if (state.isFetchError) {
 				var foschor = foschorm(context, state);
				return Stack(children: <Widget>[
	                 const HighWay(),
	                 Scaffold(
	                 	appBar: AppBar(title: Text('${state.fetchErrorMessage}', style: TextStyle(color: Colors.yellow)), backgroundColor: Colors.transparent),
		              	backgroundColor: Colors.transparent,
	    	           	body: Padding(padding: const EdgeInsets.only(left: 40, right: 40),
	        	            child: Card(color: Colors.black54,
		        	           child: Column(children: foschor))),

	                   floatingActionButton: StoreConnector<AppState, _ViewModel>(
 						converter: (store) => _ViewModel.create(store),
    					builder: (context, viewmodel) {
 							return Padding(padding: EdgeInsets.all(32), child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
 								children: <Widget>[
 									FloatingActionButton.extended(
				   						onPressed:() => viewmodel.onLogin(),
				   						label: const Text('login'),
	   			   						icon: Icon(Icons.login),
				   						backgroundColor: Colors.yellow
				   					),
				   					FloatingActionButton.extended(
				   						onPressed: () => viewmodel.onRegister(RegisterFetch(_emailController.text, _usernameController.text, _passwordController.text)),
				   						label: const Text('register'),
				   						icon: Icon(Icons.app_registration),
				   						backgroundColor: Colors.yellow
				   					)
 								])
 							);
  						}
  					))
                ]);

  			}
  			else if (state.isFetchSuccess) {
  				return Stack(children: <Widget>[
  					const HighWay(),
 					Scaffold(
						appBar: AppBar(title: Text('Please confirm your e-mail', style: TextStyle(color: Colors.yellow)), backgroundColor: Colors.transparent),
		              	backgroundColor: Colors.black54,
	                )
  				]);
  			}
			else if (!state.isFetch) {
 				 var foschor = foschorm(context, state);
                 return Stack(children: <Widget>[
                 const HighWay(),
                 Scaffold(
	              	backgroundColor: Colors.transparent,
    	           	body: Padding(padding: const EdgeInsets.only(left: 40, right: 40),
        	            child: Card(color: Colors.black54,
	        	           child: Column(children: foschor))),
	        	   floatingActionButton: StoreConnector<AppState, _ViewModel>(
 						converter: (store) => _ViewModel.create(store),
    					builder: (context, viewmodel) {
 							return Padding(padding: EdgeInsets.all(32), child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
 								children: <Widget>[
 									FloatingActionButton.extended(
				   						onPressed:() => viewmodel.onLogin(),
				   						label: const Text('login'),
	   			   						icon: Icon(Icons.login),
				   						backgroundColor: Colors.yellow
				   					),
				   					FloatingActionButton.extended(
				   						onPressed: () => viewmodel.onRegister(RegisterFetch(_emailController.text, _usernameController.text, _passwordController.text)),
				   						label: const Text('register'),
				   						icon: Icon(Icons.app_registration),
				   						backgroundColor: Colors.yellow
				   					)
 								])
 							);
  						}
  					)
                  )
                ]);
			} else if (state.isFetch) {
                return Stack(children: const <Widget>[
                  HighWay(),
                  Padding(padding: EdgeInsets.only(left: 40, right: 40),
                      child: Card(color: Colors.black54,
                          child: LinearProgressIndicator()))
                ]);
			}
			else return HighWay();
  		}
  	);
  }
}
class _ViewModel {
	final Function onLogin;
	final Function(RegisterFetch) onRegister;
	_ViewModel({
		required this.onLogin,
		required this.onRegister
	});
	factory _ViewModel.create(Store<AppState> store) {
		_onLogin() {
			store.dispatch(NavigateToAction.replace('/login'));
		}
		_onRegister(RegisterFetch rf) {
			store.dispatch(rf);
		}
		return _ViewModel(
			onLogin: _onLogin,
			onRegister: _onRegister
		);
	}
}

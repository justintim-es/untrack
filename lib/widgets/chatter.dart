import 'package:flutter/material.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/profile/reducer.dart';
import 'package:frontend/redux/models.dart';
import 'package:redux/redux.dart';

class Chatter extends StatelessWidget {
	Widget build(BuildContext context) {
		final args = ModalRoute.of(context)!.settings.arguments as Follower;
		return StoreConnector<AppState, _ViewModel>(
			converter: (store) => _ViewModel.create(store),
			builder: (context, state) {
				if (state.isFetch) {
					return Stack(children: <Widget>[
						HighWay(),
						LinearProgressIndicator()
					]);
				}
				return Stack(children: <Widget>[
						HighWay(),
						DefaultTabController(
							length: 3,
							child: Stack(children: <Widget>[
													HighWay(),
													Scaffold(
											appBar: AppBar(
												title: Text('${args.nickname}'),
												backgroundColor: Colors.black54,
												actions: <Widget>[
													IconButton(icon: Icon(Icons.app_blocking), onPressed: () => showDialog(
														context: context,
														builder: (BuildContext context) => AlertDialog(
															backgroundColor: Colors.black,
															title: const Text('Are you sure?'),
															content: const Text('Your ID wil change for everyone except for him/hers'),
															actions: <Widget> [
																TextButton(
																	onPressed: () => Navigator.pop(context),
																	child: const Text('cancel'),
																),
																TextButton(
																	onPressed: () => state.block(args.encryptedId),
																	child: const Text('change')
																)
															]
														)
													))
												],
												bottom: TabBar(
													indicatorColor: Colors.yellow,
													tabs: <Widget>[
														Tab(icon: Icon(Icons.arrow_upward)),
														Tab(icon: Icon(Icons.arrow_downward)),
														Tab(icon: Icon(Icons.chat))
													]
												)),
												backgroundColor: Colors.black54,
												body: TabBarView(
													children: <Widget>[
														ListView.builder(
															itemCount: state.following.length,
															itemBuilder: (context, index) {
																return Padding(padding: EdgeInsets.all(32), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
																	Text('${state.following[index].nickname}', style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold)),
																	state.following[index].mutual ? IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.yellow), onPressed: () => state.refreshChatter(state.following[index].encryptedId!, state.following[index].nickname!)) : Container()
																]));
															}
														),
														ListView.builder(
															itemCount: state.followers.length,
															itemBuilder: (context, index) {
																return Padding(padding: EdgeInsets.all(32), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
																	Text('${state.followers[index].nickname}', style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold)),
																	state.followers[index].mutual ? IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.yellow), onPressed: () => state.refreshChatter(state.followers[index].encryptedId!, state.followers[index].nickname!)) : Container()
																]));
															}
														),
														DefaultTabController(
															length: 2,
															child: Scaffold(
																appBar: AppBar(
																	automaticallyImplyLeading: false,
																	backgroundColor: Colors.black54,
																	bottom: TabBar(
																		indicatorColor: Colors.yellow,
																		tabs: <Widget>[
																			Tab(icon: Icon(Icons.arrow_upward)),
																			Tab(icon: Icon(Icons.arrow_downward)),
																		]
																	)
																),
																backgroundColor: Colors.black54,
																body: TabBarView(
																		children: <Widget>[
																			ListView.builder(
																				itemCount: state.outgoing.length,
																				itemBuilder: (context, index) {
																					return Container(
																						padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
																						child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,  children: <Widget>[
																								Align(
																										alignment: Alignment.topRight,
																										child: Container(
																													decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(20),
																															color: Colors.yellow,
																													),
																													padding: const EdgeInsets.all(16),
																													child: Row(children: <Widget>[
																																state.outgoing[index].isMutual ? IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.black, size: 20), onPressed: () => state.navigateChatter(Follower(encryptedId: state.outgoing[index].encryptedId!, nickname: state.outgoing[index].toFrom)), constraints: BoxConstraints(), padding: EdgeInsets.zero) : Container(),
																															Text(state.outgoing[index].toFrom, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
																													])
																										)),
																									Align(
																										alignment: Alignment.topRight,
																										child: Container(
																													decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(20),
																															color: Colors.yellow,
																													),
																													padding: EdgeInsets.all(16),
																													child: Tooltip(message: '${state.outgoing[index]!.date.toLocal()}', child: Text(state.outgoing[index].value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))
																										)
																										)
																									])
																						);
																				}
																			),
																			ListView.builder(
																				itemCount: state.incoming.length,
																				itemBuilder: (context, index) {
																					return Container(
																							padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
																							child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
																								Align(
																									alignment: Alignment.topLeft,
																									child: Container(
																												decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(20),
																														color: Colors.yellow,
																												),
																												padding: const EdgeInsets.all(16),
																												child: Tooltip(message: '${state.incoming[index]!.date.toLocal()}', child: Text(state.incoming[index].value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))
																									)
																								),
																								Align(
																									alignment: Alignment.topRight,
																									child: Container(
																												decoration: BoxDecoration(
																														borderRadius: BorderRadius.circular(20),
																														color: Colors.yellow,
																												),
																												padding: const EdgeInsets.all(16),
																												child: Row(children: <Widget>[
																													Text(state.incoming[index].toFrom, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
																															state.incoming[index].isMutual ? IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.black, size: 20), onPressed: () => state.navigateChatter(Follower(encryptedId: state.incoming[index].encryptedId!, nickname: state.incoming[index].toFrom)), constraints: BoxConstraints(), padding: EdgeInsets.zero) : Center()
																													])
																										))])
																									);
																								}
																							)])
																			)
												)])
											,floatingActionButton: FloatingActionButton(
												child: Icon(Icons.chat),
												onPressed: () => state.navigateChat(args)
											)),
										])
											)
										]);
			},
			onInit: (store) => store.dispatch(FetchProfileAction(args.encryptedId))
		);
	}
}
class _ViewModel {
	final Function(String, String) refreshChatter;
	final Function(Follower) navigateChatter;
	final Function(Follower) navigateChat;
	final Function(String) block;
	final List<ProfileFollow> following;
	final List<ProfileFollow> followers;
	final List<ShowMsg> incoming;
	final List<ShowMsg> outgoing;
	final bool isFetch;
	_ViewModel({
		required this.refreshChatter,
		required this.navigateChatter,
		required this.navigateChat,
		required this.block,
		required this.following,
		required this.followers,
		required this.incoming,
		required this.outgoing,
		required this.isFetch
	});
	factory _ViewModel.create(Store<AppState> store) {
		_refreshChatter(String encryptedId, String nickname) {
			store.dispatch(RefreshAndNavigateProfileAction(encryptedId, nickname));
		}
		_navigateChatter(Follower follower) {
			store.dispatch(NavigateToAction.replace('/chatter', arguments: follower));
		}
		_navigateChat(Follower follower) {
			store.dispatch(NavigateToAction.replace('/chat', arguments: follower));
		}
		_block(String encryptedId) {
			store.dispatch(BlockProfileAction(encryptedId));
		}
		return _ViewModel(
			refreshChatter: _refreshChatter,
			navigateChatter: _navigateChatter,
			navigateChat: _navigateChat,
			block: _block,
			following: store.state.profile.following,
			followers: store.state.profile.followers,
			incoming: store.state.profile.incoming,
			outgoing: store.state.profile.outgoing,
			isFetch: store.state.profile.isFetch,
		);
	}
}

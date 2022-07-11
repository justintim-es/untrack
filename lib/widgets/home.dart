import 'package:flutter/material.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:redux/redux.dart';
import 'package:frontend/redux/bottom_nav/reducer.dart';
import 'package:frontend/redux/you/reducer.dart';
import 'package:frontend/redux/models.dart';
import 'package:frontend/redux/home/reducer.dart';
import 'package:frontend/redux/conversations/reducer.dart';
import 'package:frontend/redux/stream/reducer.dart';
import 'package:frontend/widgets/stream_item.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gAds;

List<List<Widget>> body(_HomeViewModel viewModel) => [
	[
		(viewModel.isStreamIncomingFetch || viewModel.isStreamOutgoingFetch) ?
		const LinearProgressIndicator() :
		ListView.builder(
				itemCount: viewModel.streamMsgOutgoing.length,
				itemBuilder: (context, index) {
					return StreamItem(false, index, viewModel.streamMsgOutgoing[index]);
				}
			),
 			ListView.builder(
					itemCount: viewModel.streamMsgIncoming.length,
					itemBuilder: (context, index) {
						return StreamItem(true, index, viewModel.streamMsgIncoming[index]);
					}
			)
	],
	[
		ListView.builder(
			itemCount: viewModel.conversations.length,
			itemBuilder: (context, index) {
				final conv = viewModel.conversations[index] ?? List<OurMsg>.from([OurMsg(toFrom: '', encryptedId: '', value: '', date: DateTime.now())]);
				return ListTile(
					title: Text(conv.last?.toFrom ?? ''),
					subtitle: Text(conv.last?.value ?? ''),
					onTap: () => viewModel.navigateChat(Follower(encryptedId: conv.last?.encryptedId ?? '', nickname: conv.last?.toFrom ?? ''))
				);
			}
		),
		DefaultTabController(
			length: 2,
			child: Scaffold(
				appBar: AppBar(
					backgroundColor: Colors.black54,
					bottom: TabBar(
						tabs: <Widget>[
							Tab(icon: Icon(Icons.arrow_upward)),
							Tab(icon: Icon(Icons.arrow_downward))
						],
						indicatorColor: Colors.yellow
					)),
					backgroundColor: Colors.black54,
					body: TabBarView(
						children: <Widget>[
						ListView.builder(
							itemCount: viewModel.outgoings.length,
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
																		IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.black, size: 20), onPressed: () => viewModel.profileFollower(Follower(encryptedId: viewModel.outgoings[index].encryptedId, nickname: viewModel.outgoings[index].toFrom)), constraints: BoxConstraints(), padding: EdgeInsets.zero),
																		Text(viewModel.outgoings[index].toFrom, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
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
																child: Tooltip(message: '${viewModel.outgoings[index].date.toLocal()}', child: Text(viewModel.outgoings[index].value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))
													)
													)
												])
									);
							}
						),
						ListView.builder(
							itemCount: viewModel.incomings.length,
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
															child: Tooltip(message: '${viewModel.incomings[index]!.date.toLocal()}', child: Text(viewModel.incomings[index].value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))
												)
											),
											Align(
												alignment: Alignment.topRight,
												child: Container(
															decoration: BoxDecoration(
																	color: Colors.yellow,
																	borderRadius: BorderRadius.circular(20),
															),
															padding: const EdgeInsets.all(16),
															child: Row(children: <Widget>[
																Text(viewModel.incomings[index].toFrom, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
																		IconButton(icon: Icon(Icons.add_to_home_screen, color: Colors.black, size: 20), onPressed:() => viewModel.profileFollower(Follower(encryptedId: viewModel.incomings[index].encryptedId, nickname: viewModel.incomings[index].toFrom)), constraints: BoxConstraints(), padding: EdgeInsets.zero)
																])
													))])
												);
											}
										)])
						)

					),
			],
	[
		ListView.builder(
			itemCount: viewModel.following.length,
			itemBuilder: (context, index) {
				return ListTile(
					title: Text('${viewModel.following[index].nickname}'),
					subtitle: Text('followers: ${viewModel.following[index].followers}, following:  ${viewModel.following[index].following}'),
					onTap: () => viewModel.profileFollower(viewModel.following[index])
				);
			}
		),
		ListView.builder(
			itemCount: viewModel.followers.length,
			itemBuilder: (context, index) {
				return ListTile(
					title: Text('${viewModel.followers[index].nickname}'),
					subtitle: Text('followers: ${viewModel.followers[index].followers}, following:  ${viewModel.followers[index].following}'),
					onTap: () => viewModel.profileFollower(viewModel.followers[index])
				);
			}
		)
	]
];


class Home extends StatelessWidget {
	Widget build(BuildContext context) {
		return Stack(children: [
			HighWay(),
			StoreConnector<AppState, _HomeViewModel>(
				converter: (store) => _HomeViewModel.create(store),
				builder: (context, viewModel) {
				if (!viewModel.isStreamIncomingFetch && !viewModel.isStreamOutgoingFetch) {
					return DefaultTabController(
					length: 2,
					child: Scaffold(
						appBar: AppBar(
							iconTheme: IconThemeData(
								color: Colors.yellow
							),
							title: Text('(un)trackabl.es', style: TextStyle(color: Colors.yellow)),
							backgroundColor: Colors.black54,
							actions: <Widget>[
								StoreConnector<AppState, VoidCallback>(
									converter: (store) {
										return () => store.dispatch(NavigateToAction.push('/follow'));
									},
									builder: (context, callback) {
										return IconButton(icon: Icon(Icons.add), onPressed: callback, color: Colors.yellow);
									}
								),
								StoreConnector<AppState, VoidCallback>(
									converter: (store) {
										return () => store.dispatch(NavigateToAction.replace('/qr'));
									},
									builder: (context, callback) {
										return IconButton(icon: const Icon(Icons.qr_code), onPressed: callback, color: Colors.yellow);
									}
								)
							],
							bottom: (viewModel.index == 0) ?
								TabBar(
									tabs: [
										const Tab(icon: Icon(Icons.arrow_upward)),
										const Tab(icon: Icon(Icons.arrow_downward))
									],
									indicatorColor: Colors.yellow
								) : (viewModel.index == 1 ? TabBar(
									tabs: [
										Tab(icon: Icon(Icons.outbond)),
										Tab(icon: Icon(Icons.other_houses))
									],
									indicatorColor: Colors.yellow
								) :
									TabBar(
									indicatorColor: Colors.yellow,
									tabs: [
										Tab(icon: Icon(Icons.arrow_upward), text: '${viewModel.following.length}'),
										Tab(icon: Icon(Icons.arrow_downward), text: '${viewModel.followers.length}')
									]
								))
						),
						body: !viewModel.isStreamIncomingFetch ? TabBarView(
							children: body(viewModel)[viewModel.index]
						) : null,
						backgroundColor: Colors.black54,
						bottomNavigationBar: BottomNavigationBar(
									backgroundColor: Colors.black,
									selectedItemColor: Colors.yellow,
									currentIndex: viewModel.index,
									onTap:(i) => viewModel.navigate(i),
									items: const <BottomNavigationBarItem>[
										BottomNavigationBarItem(
											icon: Icon(Icons.dynamic_feed),
											label: 'stream'
										),
										BottomNavigationBarItem(
											icon: Icon(Icons.chat),
											label: 'chat',
										),
										BottomNavigationBarItem(
											icon: Icon(Icons.flash_on),
											label: 'followers'
										),

									]
								)
					)
				);
			} else {
				return LinearProgressIndicator();
			}

			},
			      onInit: (store) => [store.dispatch(FetchHomeAction()), store.dispatch(FetchConversationsAction()), store.dispatch(FetchStreamAction()), store.dispatch(FetchYou())],
			)
		]);
	}
}
class _HomeViewModel {
	final bool isStreamIncomingFetch;
	final bool isStreamOutgoingFetch;
	final List<Follower> followers;
	final List<Follower> following;
	final List<OurMsg> incomings;
	final List<OurMsg> outgoings;
	final int index;
	final Function(int) navigate;
	final Function(Follower) profileFollower;
	final Function fetchStreamAction;
	final Function(Follower) navigateChat;
	final List<List<OurMsg>> conversations;
	final List<StreamMsg> streamMsgOutgoing;
	final List<StreamMsg> streamMsgIncoming;
	final Function(bool, int) fetchLike;
	_HomeViewModel({
		required this.isStreamIncomingFetch,
		required this.isStreamOutgoingFetch,
		required this.followers,
		required this.following,
		required this.index,
		required this.navigate,
		required this.profileFollower,
		required this.navigateChat,
		required this.fetchStreamAction,
		required this.incomings,
		required this.outgoings,
		required this.conversations,
		required this.streamMsgOutgoing,
		required this.streamMsgIncoming,
		required this.fetchLike
	});
	factory _HomeViewModel.create(Store<AppState> store) {
		List<Follower> followers = store.state.you.followers;
		List<Follower> following = store.state.you.following;
		int index = store.state.bottomNav.selected;
		_navigate(int i) {
			store.dispatch(BottomNavIndex(i));
		}
		_profileFollower(Follower f) {
			store.dispatch(NavigateToAction.push("/chatter", arguments: f));
		}
		_navigateChat(Follower f) {
			store.dispatch(NavigateToAction.push('/chat', arguments: f));
		}
		_fetchStreamAction(FetchStreamAction action) {
			store.dispatch(action);
		}
		_fetchLike(bool isIncoming, int msgId) {
			store.dispatch(FetchLikeStreamAction(isIncoming, msgId));
		}
		return _HomeViewModel(
			isStreamIncomingFetch: store.state.stream.isIncomingFetch,
			isStreamOutgoingFetch: store.state.stream.isOutgoingFetch,
			followers: followers,
			following: following,
			index: index,
			navigate: _navigate,
			profileFollower: _profileFollower,
			navigateChat: _navigateChat,
			fetchStreamAction: _fetchStreamAction,
			incomings: store.state.home.incomings,
			outgoings: store.state.home.outgoings,
			conversations: store.state.conversations.msgs,
			streamMsgOutgoing: store.state.outgoingStreamMsgs,
			streamMsgIncoming: store.state.incomingStreamMsgs,
			fetchLike: _fetchLike
		);
	}
}

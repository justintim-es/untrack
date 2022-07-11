import 'package:flutter/material.dart';
import 'package:frontend/widgets/helpers/border.dart';
import 'package:frontend/widgets/highway.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:frontend/redux/chat/reducer.dart';
import 'package:frontend/redux/models.dart';
import 'package:redux/redux.dart';
class Chat extends StatelessWidget {
	final _messageController = TextEditingController();
	Widget build(BuildContext context) {
		final args = ModalRoute.of(context)!.settings.arguments as Follower;
		return StoreConnector<AppState, _ViewModel>(
			converter: (store) => _ViewModel.create(store),
			builder: (store, state) {
				if(state.isFetch) {
					return Stack(children: <Widget>[
						HighWay(),
						Scaffold(
							backgroundColor: Colors.black54,
							body: LinearProgressIndicator()
						)
					]);
				}
				return Stack(children: <Widget>[
					HighWay(),
					Scaffold(
						backgroundColor: Colors.black54,
						appBar: AppBar(title: Text(''), backgroundColor: Colors.black54, actions: <Widget>[
								Row(children: <Widget>[
									Text('private'),
									Switch(
										activeColor: Colors.white,
										value: state.isPrivate,
										onChanged: (newValue) => state.switchIsPrivate(SwitchChatAction(newValue)),
									)
								])
						]),
						body: Stack(children: <Widget>[
						Padding(padding: EdgeInsets.only(bottom: 100), child:
						ListView.builder(
							itemCount: state.texts.length,
							itemBuilder: (context, index) {
							    return Container(
							    	padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
							    	child: Align(
							    		alignment: state.texts[index].ours ? Alignment.topRight : Alignment.topLeft,
							    		child: Container(
					    		          decoration: BoxDecoration(
						    		            borderRadius: BorderRadius.circular(20),
						    		            color: Colors.yellow,
					    		          ),
					    		          padding: EdgeInsets.all(16),
					    		          child: Tooltip(message: '${state.texts[index]!.date.toLocal()}', child: Text(state.texts[index].value, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)))
								    	)
								    	)
							    );
							}
						)),
						Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
						Container(
						  margin: EdgeInsets.all(15.0),
						  height: 61,
						  child: Row(
						    children: [
						      Expanded(
						        child: Container(
						          decoration: BoxDecoration(
						            color: Colors.yellow,
						            borderRadius: BorderRadius.circular(35.0),
						            boxShadow: [
						              BoxShadow(
						                  offset: Offset(0, 3),
						                  blurRadius: 5,
						                  color: Colors.black)
						            ],
						          ),
						          child: Row(
						            children: [
						              IconButton(
						                  icon: Icon(Icons.chat , color: Colors.black,), onPressed: () {}),
						              Expanded(
						                child: TextField(
								                cursorColor: Colors.black,
								                style: TextStyle(color: Colors.black),
						    	                decoration: InputDecoration(
						                      		hintText: "Message...",
						                      		hintStyle: TextStyle( color:     Colors.yellow),
						                      		border: InputBorder.none
						                      	),
						                controller: _messageController,
						              )),
						              IconButton(
						                icon: Icon(Icons.photo_camera ,  color: Colors.black),
						                onPressed: () {},
						              ),
						              IconButton(
						                icon: Icon(Icons.attach_file ,  color: Colors.black),
						                onPressed: () {},
						              )
						            ],
						          ),
						        ),
						      ),
						      SizedBox(width: 15),
							      	Container(
							        padding: const EdgeInsets.all(15.0),
							        decoration: BoxDecoration(
							            color: Colors.yellow, shape: BoxShape.circle),
							        child: InkWell(
							          child: Icon(
							            Icons.send_rounded,
							            color: Colors.black,
							          ),
							          onTap: () => state.fetchMessageChatAction(FetchMessageChatAction(_messageController.text, args.encryptedId))
							        ),
							      )
							]),
						)]),
					]))]);

			},
			onInit: (store) => store.dispatch(MessagesChatAction(args.encryptedId)),
			onWillChange: (_ViewModel? prev, _ViewModel? cur) {
				if(cur!.isFetchError!) {
					print('snackbar');
					var snackbar = SnackBar(
						content: Text('${cur!.fetchErrorMessage!}', style: TextStyle(color: Colors.yellow)),
						backgroundColor: Colors.black
					);
					ScaffoldMessenger.of(context).showSnackBar(snackbar);
				} else if (cur!.isFetchSuccess) {
					_messageController.text = '';
				}
			}
		);
	}
}
class _ViewModel {
	bool isFetch;
	bool isFetchSuccess;
	bool isFetchError;
	bool isPrivate;
	String fetchErrorMessage;
	List<ChatMsg> texts;
	final Function(FetchMessageChatAction) fetchMessageChatAction;
	final Function(SwitchChatAction) switchIsPrivate;
	_ViewModel({
		required this.isFetch,
		required this.isFetchSuccess,
		required this.isFetchError,
		required this.isPrivate,
		required this.fetchErrorMessage,
		required this.texts,
		required this.fetchMessageChatAction,
		required this.switchIsPrivate
	});
	factory _ViewModel.create(Store<AppState> store) {
		_fetchMessageChatAction(FetchMessageChatAction fmca) {
			return store.dispatch(fmca);
		}
		_switchIsPrivate(SwitchChatAction sca) {
			return store.dispatch(sca);
		}
		return _ViewModel(
			isFetch: store.state.chat.isFetch,
			isFetchSuccess: store.state.chat.isFetchSuccess,
			isFetchError: store.state.chat.isFetchError,
			isPrivate: store.state.chat.isPrivate,
			fetchErrorMessage: store.state.chat.fetchErrorMessage,
			texts: store.state.chat.text,
			fetchMessageChatAction: _fetchMessageChatAction,
			switchIsPrivate: _switchIsPrivate
		);
	}
}

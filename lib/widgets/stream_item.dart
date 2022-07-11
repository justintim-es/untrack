import 'package:flutter/material.dart';
import 'package:frontend/redux/models.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:frontend/redux/combiner.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:frontend/widgets/ad.dart';
import 'package:frontend/redux/stream_msg/reducer.dart';

class StreamItem extends StatelessWidget {
  bool isIncoming;
  int index;
  StreamMsg msg;
  final _commentController = TextEditingController();
  StreamItem(this.isIncoming, this.index, this.msg);
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.create(store),
      builder: (context, viewModel) {
        return Column(children: <Widget>[
        		Center(child: Column(children: <Widget>[
          (index % 10 == 0) ?  Ad() : Container(),
          Card(
          color: Colors.yellow,
          child: Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                Column(children: <Widget>[
                  msg.isToMe ?
                  const Icon(Icons.home, color: Colors.black, size: 20) :
                  (msg.isToMutual ?
                    IconButton(icon:
                      const Icon(Icons.add_to_home_screen, color: Colors.black, size: 20),
                      onPressed: () => viewModel.profileFollower(Follower(encryptedId: msg.toEncryptedId!, nickname: msg.to!)),
                      constraints: const BoxConstraints(), padding: EdgeInsets.zero) : const Icon(Icons.enhanced_encryption, color: Colors.black, size: 20)),
                      Text('to: ${msg.to!}', style: TextStyle(color: Colors.black, fontSize: 10)),
                ]),
                SizedBox(width: 150, child: Text('${msg.value!}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                Column(children: <Widget>[
                  msg.isFromMe ? const Icon(Icons.home, color: Colors.black, size: 20) :
                  (msg.isFromMutual ?
                    IconButton(icon: const Icon(Icons.add_to_home_screen, color: Colors.black, size: 20),
                      onPressed: () => viewModel.profileFollower(Follower(encryptedId: msg.fromEncryptedId!, nickname: msg.from!)),
                      constraints: BoxConstraints(), padding: EdgeInsets.zero) : const Icon(Icons.enhanced_encryption, color: Colors.black, size: 20)),
                  Text('from: ${msg.from!}', style: TextStyle(color: Colors.black, fontSize: 10)),
                ]),
              ])]))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    IconButton(icon: Icon(msg.likes.any((l) => l.isOurs) ? Icons.favorite : Icons.favorite_border, color: Colors.white), onPressed: () => msg.likes.any((l) => l.isOurs) ? viewModel.unlike(UnlikeStreamMsgAction(isIncoming, msg.msgId)) : viewModel.fetchLike(FetchLikeStreamMsgAction(isIncoming, msg.msgId))),
                    Text('${msg.likes.length}', style: TextStyle(color: Colors.white))
                  ]),
                  TextButton(child: Text('${msg.comments.length > 0 ? msg.comments.last.value : ''}', style: TextStyle(color: Colors.white)), onPressed: () {
                  	showModalBottomSheet(
                  		context: context,
                  		backgroundColor: Colors.black54,
                  		builder: (BuildContext context) {
							return ListView.builder(
								itemCount: msg.comments.length,
								itemBuilder: (context, index) {
									return ListTile(title: Text(msg.comments[index].value));
								}
							);                  			
                  		}
                  	);
                  }),
                  IconButton(icon: Icon(Icons.chat, color: Colors.white), onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.black,
                      builder: (BuildContext context) {
                        return Container(
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
                        						                controller: _commentController,
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
                        							          onTap: () => viewModel.comment(FetchCommentStreamMsgAction(isIncoming, msg.msgId, _commentController.text))
                        							        ),
          							      )]));
                      }
                    );
                  })
                ]
              )
          ])),
          ]);
      }
    );
  }
}

class _ViewModel {
  final Function(Follower) profileFollower;
  final Function(FetchLikeStreamMsgAction) fetchLike;
  final Function(UnlikeStreamMsgAction) unlike;
  final Function(FetchCommentStreamMsgAction) comment;
  _ViewModel({
    required this.profileFollower,
    required this.fetchLike,
    required this.unlike,
    required this.comment
  });

  factory _ViewModel.create(Store<AppState> store) {
    _profileFollower(Follower f) {
      store.dispatch(NavigateToAction.push("/chatter", arguments: f));
    }
    _fetchLike(FetchLikeStreamMsgAction flsma) {
      store.dispatch(flsma);
    }
    _unlike(UnlikeStreamMsgAction usma) {
      store.dispatch(usma);
    }
    _comment(FetchCommentStreamMsgAction fcsma) {
      store.dispatch(fcsma);
    }
    return _ViewModel(
      profileFollower: _profileFollower,
      fetchLike: _fetchLike,
      unlike: _unlike,
      comment: _comment
    );
  }


}

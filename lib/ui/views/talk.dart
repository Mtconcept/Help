import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help/app/locator.dart';
import 'package:help/constants/colors.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/shared_views/loading_anim.dart';
import 'package:help/views/chat.dart';
import 'package:help/views/login/login_controller.dart';

class Talk extends StatefulWidget {
  @override
  _TalkState createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  Users _users = Users();

  @override
  Widget build(BuildContext context) {
    _users.listOfUsers();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Center(
                child: Image.asset('assets/images/talk big.png', width: 60),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Talk To Someone',
                  style: TextStyle(fontSize: 20, color: kBgColor),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: width,
                height: height,
                padding: EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                  color: klightGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder(
                  stream: _users.listOfUsers(),
                  builder: (context, snapshot) {
                    QuerySnapshot users = snapshot.data;
                    if (users == null) return Container(color: Colors.red);
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return LoadingAnim();
                    //Todo: Implement Error Screen

                    if (users.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: users.docs.length,
                        itemBuilder: (context, index) {
                          //Todo: work on unseen messages function and date
                          return ChatTile(
                            name: users.docs[index].data()['fullName'],
                            jobPosition: 'Health Care Agents',
                            date: '12/02/2012',
                            onPressed: () {
                              // print(_users.isActivist);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => Chat(
                                    currentUserId: _users.userId,
                                    recipientInfo: users.docs[index],
                                    isActivist: _users.isActivist,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return Center();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String jobPosition;
  final String date;
  final int unreads;
  final void Function() onPressed;

  const ChatTile({
    Key key,
    this.name,
    this.jobPosition,
    this.onPressed,
    this.date,
    this.unreads,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: kBgColor),
                ),
                unreads != null
                    ? CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 12,
                        child: Text('$unreads'),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jobPosition,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class Users extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isActivist = locator<StorageUtil>().isActivist;
  String get userId => auth.currentUser.uid;

  Stream listOfUsers() {
    // print(auth.currentUser.uid);
    String currentUser = auth.currentUser.uid;
    // auth.currentUser.getIdTokenResult().then((idTokenResult) {
    //   isActivist = idTokenResult.claims['isActivist'];
    //   notifyListeners();
    //   return isActivist;
    // });

    ///ERROR IS FROM HERE!!!!
    ///Hot reload and it will continue
    // check if user is an activist
    if (isActivist) {
      List<String> userIds = [];

      //getting docs in regular users collection
      Stream<QuerySnapshot> usersDb = _firestore
          .collection("users")
          .doc("regular_users")
          .collection("users")
          .snapshots();

      //getting docs in current user collection in chats collection
      Stream<QuerySnapshot> chatsDb = _firestore
          .collection('chats')
          ?.doc('social_activist')
          ?.collection(currentUser)
          ?.snapshots();

      chatsDb.listen((event) {
        event.docs.forEach((chat) {
          if (!chat.data()['isSender']) userIds.add(chat.data()['senderId']);
        });
        // print(userIds);
      });

      //list of user Ids in the userIds list that are in the user collection
      Stream<QuerySnapshot> users = usersDb.where((user) {
        // print('starting');
        for (QueryDocumentSnapshot person in user.docs) {
          if (userIds.contains(person.id)) {
            // print(person.id);
            return true;
          }
        }
        return false;
      });
      return users;
    } else {
      Stream<QuerySnapshot> db = _firestore
          .collection("users")
          .doc("social_activist")
          .collection("users")
          .snapshots();
      Stream<QuerySnapshot> users = db;
      return users;
    }
  }
}

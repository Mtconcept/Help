import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/core/models/chats_tile.dart';
import 'package:help/core/models/contacts.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:help/ui/shared_views/loading_anim.dart';
import 'package:help/ui/views/chat/chat.dart';
import 'package:help/ui/views/talk/talk_controller.dart';

class Talk extends StatefulWidget {
  @override
  _TalkState createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GetBuilder<TalkController>(
      init: TalkController(),
      builder: (model) {
        return Scaffold(
          backgroundColor: kWhite,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      // model.sendMessage('hi there', false);
                      print('sent');
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
                    child: StreamBuilder<List<Contacts>>(
                      stream: model.controller.stream,
                      builder: (context, snapshot) {
                        List<Contacts> users = snapshot.data;
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Column(
                            children: [
                              Expanded(flex: 2, child: LoadingAnim()),
                              Spacer(),
                            ],
                          );
                        else if (snapshot.hasError)
                          return Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          size: 30,
                                        ),
                                        Text(
                                          'Error Occured',
                                          style: TextStyle(
                                            color: kBgColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Spacer(),
                            ],
                          );
                        else if (users.isNull || users.isEmpty)
                          return Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      'You do not have any messages at this moment!',
                                      style: TextStyle(
                                        color: kBgColor.withOpacity(0.7),
                                      ),
                                    ),
                                  )),
                              Spacer(),
                            ],
                          );
                        //TODO: Implement Error Screen
                        else
                          return ListView.builder(
                            controller: _controller,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              Contacts user = snapshot.data[index];
                              //TODO: work on unseen messages function and date
                              return ChatTile(
                                name: user.details.data()['fullName'],
                                jobPosition: 'Health Care Agents',
                                date: user.toDateString(),
                                unreads: model.getUnreads(user.details.id),
                                onPressed: () {
                                  Get.to(Chat(
                                    currentUserId: model.currentUser,
                                    recipientInfo: users[index].details,
                                    isActivist: model.isActivist,
                                  ));
                                },
                              );
                            },
                          );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// if (snapshot.connectionState == ConnectionState.waiting)
//                           return Column(
//                             children: [
//                               Expanded(flex: 2, child: LoadingAnim()),
//                               Spacer(),
//                             ],
//                           );
//                         else if (snapshot.hasError) {
//                           return Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Icon(Icons.cancel, size: 30),
//                               Text(
//                                 'Error Occured!',
//                                 style: TextStyle(
//                                   color: kBgColor.withOpacity(0.7),
//                                 ),
//                               ),
//                             ],
//                           );
//                         } else if (users.isEmpty)
//                           return Column(
//                             children: [
//                               Expanded(
//                                   flex: 2,
//                                   child: Center(
//                                     child: Text(
//                                       'You do not have any messages at this moment!',
//                                       style: TextStyle(
//                                         color: kBgColor.withOpacity(0.7),
//                                       ),
//                                     ),
//                                   )),
//                               Spacer(),
//                             ],
//                           );
//                         else
//                           return ListView.builder(
//                             controller: _controller,
//                             itemCount: users.length,
//                             itemBuilder: (context, index) {
//                               //TODO: job description
//                               return ChatTile(
//                                 name: users[index].details.data()['fullName'],
//                                 jobPosition: 'Health Care Agents',
//                                 date: users[index]?.toDateString(),
//                                 unreads: users[index].unReads,
//                                 onPressed: () {
//                                   print(model.userId);
//                                   Get.to(Chat(
//                                     currentUserId: model.userId,
//                                     recipientInfo: users[index].details,
//                                     isActivist: model.isActivist,
//                                   ));
//                                 },
//                               );
//                             },
//                           );

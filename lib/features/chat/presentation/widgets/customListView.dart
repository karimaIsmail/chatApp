import 'dart:typed_data';

import 'package:chatapp/features/chat/presentation/screens/chatScreen.dart';
import 'package:chatapp/features/chat/presentation/widgets/lastMessage.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CustomListViewBuilder extends StatefulWidget {
  final String category;
  const CustomListViewBuilder({
    super.key,
    required this.category,
  });
  @override
  State<CustomListViewBuilder> createState() => _CustomListViewBuilder();
}

class _CustomListViewBuilder extends State<CustomListViewBuilder>
    with SingleTickerProviderStateMixin {
  late String _currentUserid;
  List data = [];
  Model model = Model();
  final _currentUser = FirebaseAuth.instance.currentUser;
  late bool isLoading = true;
  //

  String? lastMessageDate;
  int unseenCount = 0;

  late Stream<QuerySnapshot> _usersStream;
  String? currentDate;
  String? content;
  late List<Map<String, dynamic>> forward = [];
  late List users;
  late List _allData;
  String _groupMessageReceivers() {
    String users = '';
    for (var user in forward) {
      users += user['name'] + ',';
    }
    if (users.startsWith(',')) {
      users.substring(1);
    }
    return users;
  }

  void _sendBatchMessages(
      String senderId, List<Map<String, dynamic>> receiverIds) {
    List<String> receiversIdList =
        receiverIds.map((user) => user['id'].toString()).toList();
    for (int i = 0; i < model.MessageContent.length; i++) {
      _sendBatchMessage(
          senderId,
          receiversIdList,
          model.MessageContent[i]['isimage'] == true
              ? ''
              : model.MessageContent[i]['content'],
          model.MessageContent[i]['isimage'] == true
              ? model.MessageContent[i]['content']
              : '');
    }
  }

  void _sendBatchMessage(String senderId, List<String> receiverIds,
      String message, String imagepath) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    Uuid uuid = Uuid();
    DateTime now = DateTime.now();
    String currentTime = DateFormat('h:mm a').format(now);
    String currentDay = DateFormat('yyyy-MM-dd').format(now);
    String formattedDate = DateFormat('d MMMM yyyy').format(now);

    for (String receiverId in receiverIds) {
      String messageId = uuid.v4();
      DocumentReference senderMessagesRef = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(senderId)
          .collection(receiverId)
          .doc(messageId);
      DocumentReference receiverMessagesRef = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(receiverId)
          .collection(senderId)
          .doc(messageId);

      Map<String, dynamic> messageData = {
        'messageText': message,
        'senderId': senderId,
        'receiverid': receiverId,
        'day': formattedDate,
        'currentDate': currentDay,
        'time': currentTime,
        'timeStamp': FieldValue.serverTimestamp(),
        'seen': false,
        'imoji': -1,
        'replyonid': '',
        'reply': "",
        'imagepath': imagepath
      };

      batch.set(senderMessagesRef, messageData);
      batch.set(receiverMessagesRef, messageData);
    }

    try {
      await batch.commit();
      print('Messages sent successfully');
    } catch (e) {
      print('Error sending messages: $e');
    }
  }

  List _filterData(String query) {
    List users = _allData.where((doc) {
      String name = (doc.data() as Map<String, dynamic>)['username'];
      return name.contains(query);
    }).toList();
    return users;
  }
  // تحديد تنسيق التاريخ

  Future<Uint8List?> fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      return null;
    }
    return null;
  }

  //

  // تحويل السلسلة النصية إلى DateTime
  late UsersFilter _filter;
  @override
  void initState() {
    _filter = UsersFilter();

    String category = widget.category;
    _currentUserid = FirebaseAuth.instance.currentUser!.uid;
    _usersStream = FirebaseFirestore.instance
        .collection('usersInfo')
        .where('category', isEqualTo: category)
        .snapshots();

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChandeDendencies() {
    model = Provider.of<Model>(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Model>(context, listen: false);

    _filter = Provider.of<UsersFilter>(context, listen: true);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child:
              //
              Column(
            children: [
              Expanded(
                flex: 5,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                child: CircularProgressIndicator(
                          color: model.MainColor,
                        )));
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'no users found',
                            style: TextStyle(
                              color: model.MainColor,
                            ),
                          ),
                        );
                      }
                      // users = snapshot.data!.docs
                      //     .where((doc) => doc.id != _currentUser!.uid)
                      //     .toList();
                      _allData = snapshot.data!.docs
                          .where((doc) => doc.id != _currentUser!.uid)
                          .toList();

                      if (_filter.FilterText != '') {
                        users = _filterData(_filter.FilterText);
                      } else {
                        users = _allData;
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, i) {
                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          model.UserInfoID(users[i]['id']);
                                          model.SetUsername(
                                              users[i]['username']);
                                          model.SetSelectedUsernetImage(
                                              users[i]['imagepath']);
                                          model.Setcategory(
                                              users[i]['category']);

                                          model.SetLastSeen(
                                              DateFormat('yyyy-MM-dd - hh:mm a')
                                                  .format(users[i]['lastseen']
                                                      .toDate()));

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Sendreceivemessages()));
                                        },
                                        onLongPress: () {
                                          if (model.MessageContent.length ==
                                              0) {
                                            return;
                                          }
                                          setState(() {
                                            forward.add({
                                              'index': i,
                                              'id': users[i].id,
                                              'name': users[i]['username']
                                            });
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              height: 50,
                                              width: 50,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: (users[i]
                                                              ['imagepath'] ==
                                                          '')
                                                      ? Image.asset(
                                                          model.ImagePath,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          users[i]['imagepath'],
                                                          fit: BoxFit.cover,
                                                        )),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            LastMessageScreen(
                                              userId1: users[i]['id'],
                                              currentuserId: _currentUserid,
                                              username: users[i]['username'],
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Divider(
                                        color: Colors.grey[200],
                                        thickness: 2,
                                      ),
                                    )
                                  ],
                                ),
                                if (forward.any((user) => user['index'] == i))
                                  Positioned.fill(
                                      child: InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        forward.removeWhere(
                                            (user) => user['index'] == i);
                                        if (forward.isEmpty) {
                                          model.MessageContent.clear();
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(20),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          left: 40,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green[700],
                                            radius: 10,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                              ],
                            );
                          });
                    }),
              ),
              if (forward.isNotEmpty)
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadiusDirectional.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                                child: Text(_groupMessageReceivers())),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  setState(() {
                                    _sendBatchMessages(_currentUserid, forward);
                                    forward.clear();
                                    model.MessageContent.clear();
                                    Get.to(Sendreceivemessages());
                                  });
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: model.MainColor,
                                )),
                          ),
                        ],
                      ),
                    ))
            ],
          ),
        ),
      ],
    );
  }
}

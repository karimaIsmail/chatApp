import 'package:chatapp/core/localization/localController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LastMessageScreen extends StatelessWidget {
  final String userId1;
  final String currentuserId;
  final String username;

  LastMessageScreen(
      {super.key,
      required this.userId1,
      required this.currentuserId,
      required this.username});
  final MylocalController mylocalController = Get.find();
  final DateFormat longFormat = DateFormat("d MMMM");
  final DateFormat shortFormat = DateFormat("MM/dd/yyyy");
  // DateTime dateTime = longFormat.parse(dateString);
  // DateTime dateTime = shortFormat.parse(dateString);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 10,
      width: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersInfo')
            .doc(currentuserId)
            .collection(userId1)
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.hasError) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "",
                  ),
                ],
              ),
            );
          }

          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          Timestamp startOfToday = Timestamp.fromDate(today);
          var lastMessage = snapshot.data!.docs.first;
          bool seen = lastMessage['seen'];
          bool image = lastMessage['imagepath'] != '';
          String receiverId = lastMessage['receiverid'];
          bool receivedAndNotSeen = (receiverId == currentuserId) && !seen;
          String content = lastMessage['messageText'] ?? '';
          content = content.length > 12 ? content.substring(0, 10) : content;
          String currentDate = lastMessage['time'] ?? '';
          Timestamp time = lastMessage['timeStamp'];
          if (time.compareTo(startOfToday) < 0) {
            currentDate = lastMessage['currentDate'] ?? '';
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currentDate,
                        style: TextStyle(
                            color: receivedAndNotSeen
                                ? Colors.green[800]
                                : Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (lastMessage['receiverid'] != currentuserId)
                            Icon(
                              Icons.done_all,
                              color: lastMessage['seen']
                                  ? Colors.blue
                                  : Colors.grey[600],
                            ),
                          image
                              ? Icon(
                                  Icons.image,
                                  color: Colors.grey[600],
                                )
                              : Text(
                                  content,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                        ],
                      ),
                      // SizedBox(
                      //   width: 2,
                      // ),
                      // if (image)
                      //   Icon(
                      //     Icons.image,
                      //     color: Colors.grey[600],
                      //   ),
                      // if (!image)
                      //   Text(
                      //     content,
                      //     style: TextStyle(color: Colors.grey[600]),
                      //   ),

                      // Expanded(child: Text('')),

                      UnreadMessagesCount(
                          userId1: userId1, currentuserId2: currentuserId),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UnreadMessagesCount extends StatelessWidget {
  final String userId1;
  final String currentuserId2;
  const UnreadMessagesCount({
    super.key,
    required this.userId1,
    required this.currentuserId2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersInfo')
            .doc(currentuserId2)
            .collection(userId1)
            .where('receiverid', isEqualTo: currentuserId2) //
            .where('seen', isEqualTo: false) //
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }

          if (snapshot.hasError) {
            return Text('');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('');
          }

          int unreadCount = snapshot.data!.docs.length;

          return Container(
            width: 20,
            // height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: unreadCount == 0 ? Colors.white : Colors.green[700]),
            child: Text(
              unreadCount == 0 ? "" : "$unreadCount",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

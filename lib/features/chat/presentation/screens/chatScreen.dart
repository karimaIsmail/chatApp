import 'dart:io';

import 'package:chatapp/core/localization/localController.dart';
import 'package:chatapp/features/chat/presentation/widgets/customShowModelSheet.dart';
import 'package:chatapp/features/chat/presentation/widgets/replyMessageBox.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/wavyText.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Sendreceivemessages extends StatefulWidget {
  const Sendreceivemessages({super.key});

  @override
  State<Sendreceivemessages> createState() => _SendreceivemessagesState();
}

class _SendreceivemessagesState extends State<Sendreceivemessages>
    with TickerProviderStateMixin {
  Model model = Model();
  late TextEditingController message;
  late String _currentTime;
  late String _currentday;
  late String _currentUserId;
  late final List<int> _index = [];
  final FocusNode _focusNode = FocusNode();
  var _messages;
  late Size _mediaSize;
  String sender = '';
  String senderId = '';

  late TextEditingController messageText = TextEditingController();
  late TextEditingController replyController = TextEditingController();

  late DateTime now;
  late String replyOnMessage;
  int _deletedReceivedMessage = 0;
  bool reply = false;
  bool _pickImage = false;
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '388585441228137',
    apiSecret: '6ych7L5KIjRx46RkibFHnRPKyXM',
    cloudName: 'dbgeoggfd',
  );
  bool isloading = false;
  File? photo;
  String? _uploadedImageUrl;
  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {});
      photo = File(pickedFile.path);
      isloading = true;
      final response = await cloudinary.upload(
        file: pickedFile.path,
        resourceType: CloudinaryResourceType.image,
      );

      setState(() {
        _uploadedImageUrl = response.secureUrl;
        if (_uploadedImageUrl != null) {
          _sendMessage(
              _currentUserId, model.UserInfoId, "", "", _uploadedImageUrl!, '');
          isloading = false;
          _pickImage = false;
        }
        // احصل على رابط URL للصورة
      });
      print("Uploaded Image URL: $_uploadedImageUrl");
    } else {
      print('No image selected.');
    }
  }

  void _sendMessage(String senderId, String receiverid, String message,
      String reply, String imagepath, String replyonid) async {
    _focusNode.unfocus();
    Uuid uuid = Uuid();
    String messageId = uuid.v4();
    now = DateTime.now();
    _currentTime = DateFormat('h:mm a').format((now));
    _currentday = DateFormat('yyyy-MM-dd').format((now));
    String formatdate = DateFormat('d MMMM yyyy').format(now);
    DocumentReference senderMessagesRef = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(senderId)
        .collection(receiverid)
        .doc(messageId);
    DocumentReference receiverMessagesRef = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(receiverid)
        .collection(senderId)
        .doc(messageId);

    Map<String, dynamic> messageData = {
      'messageText': message,
      'senderId': senderId,
      'receiverid': receiverid,
      //day in long form
      'day': formatdate,
      //day in short form

      'currentDate': _currentday,
      'time': _currentTime,
      'timeStamp': FieldValue.serverTimestamp(),
      'seen': false,
      'imoji': -1,
      'reply': reply,
      'replyonid': replyonid,

      'imagepath': imagepath
    };

    try //await senderMessagesRef.add(_messageData);
    {
      await receiverMessagesRef.set(messageData);
      await senderMessagesRef.set(messageData);
    } catch (e) {}
  }

  // DateFormat longFormat = DateFormat("d MMMM");
//
  late Stream<QuerySnapshot> _usersStream;
  List selectesMessageIndex = [];
  List imoji = [
    "❤️",
    '🤲🏻',
    '🌹',
    '😘',
    '👍🏻',
    '🌸',
    '💖',
    '🎉',
    '😅',
    '😍',
    '🌺',
    '🤣',
    '👌',
    '🤩',
    '🤝',
    '👎',
    '🙄',
    '😡'
  ];
  int? selectedImoji;

  deleteForYou() async {
    for (int i = 0; i < _index.length; i++) {
      // snapshot.data?.docs[i].id.delete;
      await FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(_currentUserId)
          .collection(model.UserInfoId)
          .doc(_messages[_index[i]].id)
          .delete();
    }
  }

  Future<void> deleteMessagesForEveryone() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (int i = 0; i < _index.length; i++) {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(_currentUserId)
          .collection(model.UserInfoId)
          .doc(_messages[_index[i]].id);

      DocumentReference recipientDocRef = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(model.UserInfoId)
          .collection(_currentUserId)
          .doc(_messages[_index[i]].id);

      // أضف عمليات الحذف إلى الدفعة
      batch.delete(userDocRef);
      batch.delete(recipientDocRef);
    }

    // نفذ الدفعة
    try {
      await batch.commit();
    } catch (e) {}
  }

  Future<void> deleteMessagesCollection(String userId) async {
    // تحديد المرجع للمجموعة
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(_currentUserId)
        .collection(userId);

    QuerySnapshot messagesSnapshot = await messagesCollection.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // تنفيذ الدفعة
    try {
      await batch.commit();
      print('Messages collection deleted successfully');
    } catch (e) {
      print('Error deleting messages collection: $e');
    }
  }

  Future<void> updateMessageSeenStatus(
      String userId, String currentUserId, String messageId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(userId)
          .collection(currentUserId)
          .doc(messageId);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.set({
          "seen": true,
        }, SetOptions(merge: true));
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> AddImoji(String userId, String currentUserId, String messageId,
      int imojiIndex) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference senderMessagesRef = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(currentUserId)
        .collection(userId)
        .doc(messageId);
    DocumentReference receiverMessagesRef = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(userId)
        .collection(currentUserId)
        .doc(messageId);

    batch.set(
        senderMessagesRef,
        {
          'imoji': imojiIndex,
        },
        SetOptions(merge: true));
    batch.set(
        receiverMessagesRef,
        {
          'imoji': imojiIndex,
        },
        SetOptions(merge: true));

    try {
      await batch.commit();
      print('Messages sent successfully');
    } catch (e) {
      print('Error sending messages: $e');
    }
  }

  void _addToForwardMessages() {
    bool isImage;
    String content;
    for (int i = 0; i < _index.length; i++) {
      isImage = _messages[_index[i]]['imagepath'] != '';
      content = (isImage)
          ? _messages[_index[i]]['imagepath']
          : _messages[_index[i]]['messageText'];
      model.AddToMessages(content, isImage);
    }
  }

  void didChandeDendencies() {
    // model = Provider.of<Model>(context, listen: true);

    super.didChangeDependencies();
  }

  MylocalController mylocalController = Get.find();
  late Stream<DocumentSnapshot> _userStatus;

  @override
  void initState() {
    model = Provider.of<Model>(context, listen: false);
    // model.SetIsChatListPage(false);
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    message = TextEditingController();
    _userStatus = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(model.UserInfoId)
        .snapshots();
    _usersStream = FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(_currentUserId)
        .collection(model.UserInfoId)
        .orderBy('timeStamp', descending: false)
        .snapshots();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Model>(context, listen: true);

    _mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: model.MainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3),
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: model.SelectedUsernetImage == ''
                              ? Image.asset(
                                  model.ImagePath,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  model.SelectedUsernetImage,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Text(
                          "${model.Username}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: _userStatus,
                          builder: (contex,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.connectionState ==
                                    ConnectionState.none) {
                              return Text('');
                            }

                            if (snapshot.hasError) {
                              return Text("",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ));
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                  child: Text("14".tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                      )));
                            }
                            final userStatus =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return (userStatus['online'])
                                ? SizedBox(
                                    width: 122,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Text(
                                        'online'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        'Last Seen',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        model.LastSeen,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    PopupMenuButton(
                        color: Colors.white,
                        offset: Offset(0, 40),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (val) {},
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                onTap: () {
                                  setState(() {
                                    Get.defaultDialog(
                                      contentPadding: EdgeInsets.all(10),
                                      titlePadding: EdgeInsets.all(10),
                                      //i can use ant widget
                                      content: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "13".tr,
                                          style:
                                              TextStyle(color: model.MainColor),
                                        ),
                                      ),
                                      title: "18".tr,
                                      titleStyle: TextStyle(
                                        color: model.MainColor,
                                      ),

                                      textCancel: '11'.tr,

                                      buttonColor: model.MainColor,
                                      cancelTextColor: model.MainColor,
                                      textConfirm: '19'.tr,
                                      confirmTextColor: Colors.white,
                                      onCancel: () {},
                                      onConfirm: () {
                                        deleteMessagesCollection(
                                            model.UserInfoId);
                                        Get.back();
                                      },
                                    );
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.cleaning_services,
                                      color: model.MainColor,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "7".tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: model.MainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                  value: 1,

                                  //when we press item
                                  onTap: () {
                                    // setState(() {
                                    model.SetShowBottomSheet(true);
                                    // });
                                  },
                                  child: Row(children: [
                                    Icon(
                                      Icons.move_to_inbox_rounded,
                                      color: model.MainColor,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("8".tr,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: model.MainColor,
                                        ))
                                  ])),
                            ])
                  ],
                ),
                if (_index.isNotEmpty)
                  Positioned(
                      child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 52,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: model.MainColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        alignment: Alignment.topLeft,
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        backgroundColor: Colors.white,
                                        icon: const Icon(Icons.warning),
                                        titleTextStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red[400]),
                                        title: Text("18".tr),
                                        content: Text("13".tr),
                                        actions: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (_deletedReceivedMessage == 0)
                                                InkWell(
                                                    child: Text("10".tr,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .red[400])),
                                                    onTap: () {
                                                      deleteMessagesForEveryone();
                                                      setState(() {
                                                        _index.clear();
                                                        _deletedReceivedMessage =
                                                            0;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    deleteForYou();
                                                    setState(() {
                                                      _index.clear();
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "9".tr,
                                                    style: TextStyle(
                                                        color: Colors.red[400]),
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                  child: Text("11".tr,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red[400])),
                                                  onTap: () {
                                                    setState(() {
                                                      _index.clear();
                                                      _deletedReceivedMessage =
                                                          0;
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  })
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              });
                            },

                            // _delete = true;

                            iconSize: 25,
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                              child: Text(
                                  _index.isEmpty ? "" : "${_index.length}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(
                            width: 20,
                          ),
                          if (_index.length == 1)
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    reply = true;
                                    _index.clear();
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.replyAll)),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _addToForwardMessages();
                                  Get.back();
                                });
                              },
                              icon: Icon(
                                Icons.forward_sharp,
                                size: 27,
                              )),
                        ],
                      ),
                    ),
                  ))
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: reply ? 4 : 5,
                  child: StreamBuilder(
                      stream: _usersStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: model.MainColor,
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child:
                                //  Column(
                                // children: [
                                // GifImage(
                                //     image: AssetImage('assets/animation.gif'),
                                //     controller: Gifcontroller),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                WavyText(
                              text: 'No Messages Here!'.tr,
                            ),
                            // ],
                            // )
                          );
                        }
                        _messages = snapshot.data!.docs.toList();

                        String previousDate = "";
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, i) {
                            //
                            bool IscurrentUser = _messages[i]['senderId'] ==
                                FirebaseAuth.instance.currentUser!.uid;

                            String messageDate = _messages[i].get('day');

                            bool showDateLabel = (messageDate != previousDate);

                            if (showDateLabel) {
                              previousDate = messageDate;
                            }

                            if (!IscurrentUser && !_messages[i]['seen']) {
                              //seen for sender and receiver
                              FirebaseFirestore.instance
                                  .collection('usersInfo')
                                  .doc(_currentUserId)
                                  .collection(model.UserInfoId)
                                  .doc(_messages[i].id)
                                  .set({
                                "seen": true,
                              }, SetOptions(merge: true));
                              updateMessageSeenStatus(model.UserInfoId,
                                  _currentUserId, _messages[i].id);
                            }

                            return Column(
                              crossAxisAlignment: IscurrentUser
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                if (showDateLabel)
                                  Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(5),
                                      width: 160,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: model.MessageColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Text(messageDate),
                                    ),
                                  ),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          if (_index.isEmpty) {
                                            replyOnMessage =
                                                _messages[i].get('messageText');
                                            sender =
                                                _messages[i].get('senderId') ==
                                                        _currentUserId
                                                    ? 'you'
                                                    : model.Username;
                                            senderId =
                                                _messages[i].get('senderId');
                                          } else {
                                            replyOnMessage = '';
                                          }
                                          if (_index.contains(i)) {
                                            _index.remove(i);
                                            if (!IscurrentUser) {
                                              _deletedReceivedMessage--;
                                            }
                                          } else {
                                            _index.add(i);
                                            if (!IscurrentUser) {
                                              _deletedReceivedMessage++;
                                            }
                                          }
                                        });
                                      },
                                      onTap: () {
                                        setState(() {
                                          if (selectesMessageIndex.isEmpty) {
                                            selectesMessageIndex.add(i);
                                          } else {
                                            selectesMessageIndex.remove(i);
                                          }
                                        });
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  // left: 8,
                                                  right: 5,
                                                  bottom: 2),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 1,
                                                        spreadRadius: 1,
                                                        offset: Offset(1, 1),
                                                        color: _messages[i].get(
                                                                    'imagepath') ==
                                                                ''
                                                            ? Colors.grey
                                                            : Colors.white),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    topLeft: IscurrentUser
                                                        ? Radius.circular(0)
                                                        : Radius.circular(20),
                                                    topRight: IscurrentUser
                                                        ? Radius.circular(20)
                                                        : Radius.circular(0),
                                                  ),
                                                  color: _index.contains(i)
                                                      ? Colors.red[100]

                                                      // : Colors.grey[50]
                                                      : IscurrentUser
                                                          ? Colors.white
                                                          : _messages[i].get(
                                                                      'imagepath') !=
                                                                  ''
                                                              ? Colors.white
                                                              : model
                                                                  .MessageColor),
                                              width: _messages[i]
                                                          .get('imagepath') ==
                                                      ''
                                                  ? _mediaSize.width * 0.80
                                                  : _mediaSize.width * 0.50,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  if (_messages[i]
                                                          ['imagepath'] !=
                                                      "")
                                                    Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            child:
                                                                Image.network(
                                                              _messages[i].get(
                                                                  'imagepath'),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 2,
                                                            left: 2,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Row(
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          WidgetSpan(
                                                                              child: SizedBox(
                                                                            width:
                                                                                10,
                                                                          )),
                                                                          TextSpan(
                                                                            text:
                                                                                "${_messages[i].get('time')}",
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: Colors.white),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  if (IscurrentUser)
                                                                    Icon(
                                                                      Icons
                                                                          .done_all_sharp,
                                                                      color: _messages[i].get('seen') ==
                                                                              true
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .grey,
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          if (_messages[i]
                                                                  ['imoji'] !=
                                                              -1)
                                                            Positioned(
                                                              bottom: -20,
                                                              right: 1,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              blurRadius: 1,
                                                                              spreadRadius: 1,
                                                                              offset: Offset(1, 1),
                                                                              color: Colors.black54),
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(30)),
                                                                height: 30,
                                                                width: 30,
                                                                child: Center(
                                                                    child: Text(
                                                                  imoji[_messages[
                                                                          i][
                                                                      'imoji']],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                )),
                                                              ),
                                                            )
                                                        ]),
                                                  // ShowPhoto(
                                                  //
                                                  if (_messages[i]
                                                              .get('reply') ==
                                                          '' &&
                                                      _messages[i].get(
                                                              'imagepath') ==
                                                          '')
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 18),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "${_messages[i].get('messageText')}",
                                                          style: TextStyle(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          softWrap: true,
                                                          maxLines: null,
                                                        ),
                                                      ),
                                                    ),
                                                  if (_messages[i]['reply'] !=
                                                      '')
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: ReplyMessageBox(
                                                              replyOn:
                                                                  _messages[i]
                                                                      ['reply'],
                                                              senderName: _messages[
                                                                              i]
                                                                          .get(
                                                                              'replyonid') !=
                                                                      _currentUserId
                                                                  ? model
                                                                      .Username
                                                                  : 'you'),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 18),
                                                            child: Text(
                                                              "${_messages[i].get('messageText')}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              softWrap: true,
                                                              maxLines: null,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  if (_messages[i]
                                                          ['imagepath'] ==
                                                      '')
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Row(
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                      child:
                                                                          SizedBox(
                                                                    width: 10,
                                                                  )),
                                                                  TextSpan(
                                                                    text:
                                                                        "${_messages[i].get('time')}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey[700]),
                                                                  )
                                                                ]),
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          if (IscurrentUser &&
                                                              _messages[i][
                                                                      'imagepath'] ==
                                                                  '')
                                                            Icon(
                                                              Icons
                                                                  .done_all_sharp,
                                                              color: _messages[
                                                                              i]
                                                                          .get(
                                                                              'seen') ==
                                                                      true
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              )),
                                          if (_messages[i]['imoji'] != -1 &&
                                              _messages[i]['imagepath'] == '')
                                            Positioned(
                                              bottom: -20,
                                              right: 8,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 1,
                                                          spreadRadius: 1,
                                                          offset: Offset(1, 1),
                                                          color:
                                                              Colors.black54),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                height: 30,
                                                width: 30,
                                                child: Center(
                                                    child: Text(
                                                  imoji[_messages[i]['imoji']],
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    if (selectesMessageIndex.contains(i))
                                      Positioned(
                                        left: 8,
                                        bottom: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 1,
                                                    spreadRadius: 1,
                                                    offset: Offset(1, 1),
                                                    color: Colors.black54),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 40,
                                          width: 250,
                                          // MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imoji.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImoji = index;
                                                    if (index ==
                                                        _messages[i]['imoji']) {
                                                      selectedImoji = -1;
                                                    }
                                                    AddImoji(
                                                        _messages[i]
                                                            ['senderId'],
                                                        _messages[i]
                                                            ['receiverid'],
                                                        _messages[i].id,
                                                        selectedImoji!);
                                                    selectesMessageIndex
                                                        .remove(i);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      imoji[index],
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
                Expanded(
                  flex: reply || _pickImage ? 3 : 1,

                  child: (reply || _pickImage)
                      ? Container(
                          padding:
                              EdgeInsets.only(left: 10, top: 10, right: 10),
                          width: _mediaSize.width * 0.9,
                          height: 100,
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black54),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      width: _mediaSize.width * 0.8,
                                      padding: EdgeInsets.only(
                                          left: 25, right: 20, top: 15),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.symmetric(
                                            vertical: BorderSide(
                                                color: model.MainColor,
                                                width: 4)),
                                        color: Colors.grey[100],
                                      ),
                                      child: _pickImage && photo != null
                                          ? Row(
                                              children: [
                                                Container(
                                                    height: 90,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                photo!),
                                                            fit:
                                                                BoxFit.cover))),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor:
                                                        model.MainColor,
                                                  ),
                                                )
                                              ],
                                            )
                                          : reply
                                              ? Text(replyOnMessage.length > 20
                                                  ? replyOnMessage.substring(
                                                      0, 20)
                                                  : replyOnMessage)
                                              : null),
                                  Positioned(
                                      top: 0,
                                      left: 7,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            reply = false;
                                          });
                                        },
                                        child: Text(
                                          'x',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  Positioned(
                                      top: 1,
                                      right: 6,
                                      child: Text(
                                        sender,
                                        style: TextStyle(
                                            color: model.MainColor,
                                            fontSize: 12),
                                      ))
                                ],
                              ),
                              TextField(
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: model.MainColor),
                                maxLines: null,
                                controller: replyController,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: model.MainColor,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: model.MainColor,
                                  )),
                                  focusColor: Colors.white,

                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  // prefix: IconButton(
                                  //   iconSize: 30,
                                  //   onPressed: () {
                                  //     _pickImage = true;
                                  //     _pickAndUploadImage();
                                  //   },
                                  //   icon: Icon(
                                  //     Icons.camera_enhance,
                                  //     color: model.MainColor,
                                  //   ),
                                  // ),
                                  suffix: IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        setState(() {
                                          if (replyController.text.isEmpty) {
                                            return;
                                          }
                                          FirebaseAuth
                                              .instance.currentUser!.uid;
                                          _sendMessage(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              model.UserInfoId,
                                              replyController.text,
                                              replyOnMessage,
                                              '',
                                              senderId);

                                          replyController.clear();
                                          reply = false;
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: Duration(seconds: 1),
                                              curve: Curves.bounceInOut);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: model.MainColor,
                                      )),
                                  // fillColor: Colors.grey[100],
                                  // filled: true,
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(
                          width: _mediaSize.width * 0.9,
                          height: 50,
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: model.MainColor),
                            //autofocus: true,
                            maxLines: null,
                            minLines: 1,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: model.MainColor,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: model.MainColor,
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              focusColor: model.MainColor,
                              prefix: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  _pickImage = true;
                                  _pickAndUploadImage();
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: model.MainColor,
                                ),
                              ),
                              suffix: IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    if (_pickImage) {
                                      return;
                                    }
                                    setState(() {
                                      if (messageText.text.isEmpty) {
                                        return;
                                      }
                                      FirebaseAuth.instance.currentUser!.uid;
                                      _sendMessage(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          model.UserInfoId,
                                          messageText.text,
                                          '',
                                          '',
                                          '');

                                      messageText.clear();
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 1),
                                          curve: Curves.bounceInOut);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: model.MainColor,
                                  )),
                              contentPadding: EdgeInsets.only(
                                left: 18,
                                right: 18,
                                top: 4,
                                bottom: 4,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '20'.tr,
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            controller: messageText,
                          ),
                        ),
                  //  ],
                  // ),
                ),
              ],
            ),
            AnimatedPositioned(
              left: 0,
              right: 0,
              bottom: model.ShowBottomSheet ? -5 : -200,
              duration: Duration(milliseconds: 500),
              child: CustomShowModelSheet(),
            )
          ],
        ),
      ),
    );
  }
}

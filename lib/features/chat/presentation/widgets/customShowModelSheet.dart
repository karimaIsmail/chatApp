import 'package:chatapp/core/localization/localController.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomShowModelSheet extends StatefulWidget {
  const CustomShowModelSheet({super.key});

  @override
  State<CustomShowModelSheet> createState() => _CustomShowModelSheetState();
}

class _CustomShowModelSheetState extends State<CustomShowModelSheet> {
  CollectionReference usersInfo =
      FirebaseFirestore.instance.collection('usersInfo');

  Model model = Model();

  void _updateCategory(String userId, String category) async {
    setState(() async {
      await usersInfo.doc(model.UserInfoId).set({
        "category": category,
      }, SetOptions(merge: true));
    });
  }

  MylocalController mylocalController = Get.find();

  @override
  Widget build(BuildContext context) {
    model = Provider.of<Model>(context, listen: false);
    int? index;
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white),
      child: Container(
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: model.MainColor),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Center(
              child: IconButton(
                  onPressed: () {
                    // setState(() {
                    model.SetShowBottomSheet(false);
                    //  }); //  navigator!.pop(context);
                  },
                  icon: Icon(
                    Icons.remove,
                    size: 40,
                    color: Colors.white,
                  )),
            ),
            // if (model.PageNumber == 0 || model.PageNumber == 1)
            if (model.Category == "normal" || model.Category == "favorit")
              // InkWell(
              //   splashColor: Colors.white,
              //   onTap: () {
              //     //setState(() async {
              //     setState(() {
              //       index = 2;
              //     });

              //     //});
              //   },
              //   child:
              Container(
                margin: EdgeInsets.all(10),
                height: 20,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateCategory(model.UserInfoId, 'spam');
                        index = 2;
                      },
                      icon: Icon(
                        Icons.block,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '16'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // if (index == 2)
                    //   Icon(
                    //     Icons.done,
                    //     color: Colors.white,
                    // )
                  ],
                ),
              ),
            // ),
            // if (model.PageNumber == 1 || model.PageNumber == 2)
            if (model.Category == "spam" || model.Category == "favorit")
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       index = 0;
              //     });

              //     // setState(() async {
              //     _updateCategory(model.UserInfoId, 'normal');
              //     // });
              //   },
              //   child:
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateCategory(model.UserInfoId, 'normal');
                        index = 2;
                      },
                      icon: Icon(
                        Icons.mail_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '15'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    // if (index == 0)
                  ],
                ),
              ),
            // ] ),
            //   if (model.PageNumber == 0 || model.PageNumber == 2)
            if (model.Category == "normal" || model.Category == "spam")
              // InkWell(
              //   onTap: () {
              //     setState(() async {
              //       index = 1;
              //       _updateCategory(model.UserInfoId, 'favorit');
              //       setState(() {});
              //     });
              //   },

              //   child:
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _updateCategory(model.UserInfoId, 'favorit');
                        index = 2;
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '17'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (index == 1)
                      Icon(
                        Icons.done,
                        color: Colors.white,
                      )
                  ],
                ),
              ),

            // RadioListTile(
            //   value: 'spam',
            //   groupValue: _groupValue,
            //   onChanged: (String? value) async {
            //     _groupValue = value!;
            //     setState(() async {
            //       await usersInfo.doc(model.UserInfoId).set({
            //         "category": "spam",
            //       }, SetOptions(merge: true));
            //     });
            //   },
            //   title: Text(
            //     'Move To spam',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //         fontWeight: FontWeight.bold),
            //   ),
            //   activeColor: Colors.white,
            // ),

            //  mail_rounded
            // RadioListTile(
            //   value: 'normal',
            //   groupValue: _groupValue,
            //   onChanged: (String? val) async {
            //     _groupValue = val!;
            //     setState(() async {
            //       await usersInfo.doc(model.UserInfoId).set({
            //         "category": "normal",
            //       }, SetOptions(merge: true));
            //     });
            //   },
            //   title: Text(
            //     'Move To normal',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //         fontWeight: FontWeight.bold),
            //   ),
            //   activeColor: Colors.white,
            // ),
            // if (model.PageNumber == 0 || model.PageNumber == 2)
            // RadioListTile(
            //   value: 'favorit',
            //   groupValue: _groupValue,
            //   onChanged: (String? val) async {
            //     _groupValue = val!;
            //     setState(() async {
            //       await usersInfo.doc(model.UserInfoId).set({
            //         "category": "favorit",
            //       }, SetOptions(merge: true));
            //     });
            //   },
            //   title: Text(
            //     'Move To favorits',
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //         fontWeight: FontWeight.bold),
            //   ),
            //   activeColor: Colors.white,
            // ),
          ])),
    );
  }
}

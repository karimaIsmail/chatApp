import 'package:chatapp/core/localization/localController.dart';
import 'package:chatapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

bool _search = false;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(
      kTextTabBarHeight + kTextTabBarHeight + (_search ? 40 : 30));
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController SearchController = TextEditingController();
  MylocalController mylocalController = Get.find();
  Model _chooseColers = Model();
  UsersFilter _filter = UsersFilter();

  @override
  Widget build(BuildContext context) {
    _chooseColers = Provider.of<Model>(context, listen: true);
    _filter = Provider.of<UsersFilter>(context, listen: false);

    return AppBar(
      // toolbarHeight: 300,
      backgroundColor: _chooseColers.MainColor,
      // actions: [

      // ],
      iconTheme: IconThemeData(color: Colors.white),

      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 30,
              ));
        },
      ),
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Text(
                  "1".tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                SizedBox(
                  width: 30,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _search = true;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ))
              ],
            ),
          ),
          if (_search)
            Positioned(
              left: -60,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                child: TextField(
                  onChanged: (val) {
                    _filter.SetFilterText(val);
                  },
                  autofocus: true,
                  minLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _chooseColers.MessageColor,
                        ),
                        borderRadius: BorderRadius.circular(80)),
                    suffix: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            SearchController.clear();
                            _filter.SetFilterText(SearchController.text);

                            _search = false;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )),
                    focusColor: _chooseColers.MainColor,
                    contentPadding: EdgeInsets.only(
                      left: 30,
                      right: 5,
                      top: 0,
                      bottom: 6,
                    ),
                    fillColor: _chooseColers.MainColor,
                    filled: true,
                    alignLabelWithHint: true,

                    /// hintText: '20'.tr,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  controller: SearchController,
                ),
              ),
            )
        ],
      ),

      bottom: TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 15),
        unselectedLabelColor: Colors.white,
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        tabs: [
          Tab(
            iconMargin: EdgeInsets.all(5),
            text: "4".tr,
            icon: Icon(
              Icons.mail_rounded,
              color: Colors.white,
            ),
          ),
          Tab(
            icon: Icon(Icons.favorite),
            child: Text(
              "2".tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Tab(
            icon: Icon(Icons.block, color: Colors.white),
            child: Text(
              "3".tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

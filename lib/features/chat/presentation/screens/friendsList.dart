import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/features/chat/presentation/cubit/settings_cubit.dart';
import 'package:chatapp/features/chat/presentation/widgets/customAppBar.dart';
import 'package:chatapp/features/chat/presentation/widgets/customDrawer2.dart';
import 'package:chatapp/features/chat/presentation/widgets/customListView.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocProvider(
        create: (context) => SettingsCubit(),
        child: Scaffold(
            backgroundColor: Colors.white,
            drawer: CustomDrawer(),
            appBar: CustomAppBar(),
            body: TabBarView(children: [
              CustomListViewBuilder(
                category: AppStrings.normal,
              ),
              CustomListViewBuilder(
                category: AppStrings.favorit,
              ),
              CustomListViewBuilder(
                category: AppStrings.spam,
              ),
            ])),
      ),
    );
  }
}

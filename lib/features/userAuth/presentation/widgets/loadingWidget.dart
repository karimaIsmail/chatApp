import 'package:chatapp/core/constants/app_strings.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/customLogo.dart';
import 'package:chatapp/features/userAuth/presentation/widgets/wavyText.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          children: [
            CustomLogo(),
            SizedBox(
              height: 50,
            ),
            loadingComponent(),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: WavyText(
                text: AppStrings.appName,

                // text: "klaT s'teL",
              ),
            )
          ],
        ),
      ),
    );
  }

  Container loadingComponent() {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(197, 121, 73, 194).withOpacity(0.5),
          borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.all(30),
      width: 100,
      height: 100,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

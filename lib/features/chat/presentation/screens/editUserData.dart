import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditUserData extends StatefulWidget {
  const EditUserData({super.key});

  @override
  State<EditUserData> createState() => _EditUserDataState();
}

DateTime now = DateTime.now();
String formattedDateEn =
    DateFormat('d MMMM yyyy', 'en_US').format(now); // تنسيق التاريخ بالإنجليزية
late String formattedDateAr; //
late bool autofocus;

class _EditUserDataState extends State<EditUserData> {
  late Size _mediaSize;
  Model model = Model();
  final TextEditingController _usernameController = TextEditingController();
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  bool isloading = false;
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '388585441228137',
    apiSecret: '6ych7L5KIjRx46RkibFHnRPKyXM',
    cloudName: 'dbgeoggfd',
  );
  final ImagePicker _picker = ImagePicker();

  String? _uploadedImageUrl;
  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isloading = true;
      setState(() {});
      final response = await cloudinary.upload(
        file: pickedFile.path,
        resourceType: CloudinaryResourceType.image,
      );

      setState(() {
        _uploadedImageUrl = response.secureUrl;
        if (_uploadedImageUrl != null) {
          updateImage();
          // model.SetImageCloud(_uploadedImageUrl);
        }
        isloading = false;
        // احصل على رابط URL للصورة
      });
      print("Uploaded Image URL: $_uploadedImageUrl");
    } else {
      print('No image selected.');
    }
  }

  Future<void> updateImage() async {
    try {
      await FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(_currentUserId)
          .update({
        'imagepath': _uploadedImageUrl,
      });
      model.SetImageChanged(true);

      print("Username updated successfully");
    } catch (e) {
      print("Error updating username: $e");
    }
  }

  late String username;
  CollectionReference usersInfo =
      FirebaseFirestore.instance.collection('usersInfo');

  @override
  void initState() {
    model = Provider.of<Model>(context, listen: false);
    _usernameController.text = model.CurrentUsername;

    super.initState();
  }

  Future<void> updateUsername() async {
    try {
      await FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(_currentUserId)
          .update({
        'username': _usernameController.text,
      });
      print("Username updated successfully");
    } catch (e) {
      print("Error updating username: $e");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mediaSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          isloading
              ? Stack(
                  children: [
                    Hero(
                        tag: "userimage",
                        child: model.NetImage == null
                            ? Image(
                                height: _mediaSize.width,
                                width: _mediaSize.width,
                                fit: BoxFit.cover,
                                image: AssetImage(model.ImagePath))
                            : Image.memory(
                                height: _mediaSize.width,
                                width: _mediaSize.width,
                                fit: BoxFit.cover,
                                model.NetImage)),
                    Positioned(
                        top: 150,
                        left: 150,
                        child: CircularProgressIndicator(
                          color: model.MainColor,
                        ))
                  ],
                )
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Hero(
                        tag: "userimage",
                        child: _uploadedImageUrl != null
                            ? Image.network(
                                height: _mediaSize.width,
                                width: _mediaSize.width,
                                fit: BoxFit.cover,
                                _uploadedImageUrl!)
                            : model.NetImage == null
                                ? Image(
                                    height: _mediaSize.width,
                                    width: _mediaSize.width,
                                    fit: BoxFit.cover,
                                    image: AssetImage(model.ImagePath))
                                : Image.memory(
                                    height: _mediaSize.width,
                                    width: _mediaSize.width,
                                    fit: BoxFit.cover,
                                    model.NetImage)),
                    Positioned(
                        left: 3,
                        top: 30,
                        child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: model.MainColor,
                              size: 30,
                            ))),
                    Positioned(
                        right: 20,
                        bottom: -20,
                        child: CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: model.MainColor,
                          child: IconButton(
                              onPressed: () {
                                // _pickImage();

                                _pickAndUploadImage();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              )),
                        ))
                  ],
                ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: model.MainColor),
              // autofocus: autofocus,
              controller: _usernameController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: model.MainColor,
                )),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: model.MainColor,
                )),

                focusColor: model.MainColor,
                prefixIcon: Icon(
                  Icons.person,
                  color: model.MainColor,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    if (_usernameController.text.isNotEmpty &&
                        _usernameController.text != model.CurrentUsername) {
                      updateUsername();
                      setState(() {
                        autofocus = false;
                      });
                      Get.snackbar(
                        '', // عنوان الـ Snackbar
                        'Data Updated Sucessfully',
                        maxWidth: _mediaSize.width,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: model.MainColor,
                        colorText: Colors.white,
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        duration: Duration(seconds: 1),
                      );
                    }
                  },
                  child: Icon(
                    Icons.done,
                    size: 40,
                    color: model.MainColor,
                  ),
                ),

                // contentPadding: EdgeInsets.symmetric(horizontal: 40),
              ),
              cursorColor: model.MainColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/views/screens/bottom_nav_screen.dart';
import 'package:tiktok_clone/views/screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  @override
  void onReady() {
    super.onReady();

    _user = Rx(firbaseAuth11.currentUser);
    _user.bindStream(firbaseAuth11.authStateChanges());
    ever(_user, _initialscreenchanger);
  }

  _initialscreenchanger(User? usser) {
    if (usser == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const BottomNavScreen());
    }
  }

  Future<String> imageupload(File imagefile) async {
    Reference ref = storage
        .ref()
        .child('profilePics')
        .child(firbaseAuth11.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(imagefile);
    TaskSnapshot snap = await uploadTask;
    String imageurl = await snap.ref.getDownloadURL();
    return imageurl;
  }

  Future<void> regester(
      {required String password,
      required String username,
      required String email,
      required File? imagefile}) async {
    if (username.isNotEmpty &
        email.isNotEmpty &
        password.isNotEmpty &
        (imagefile != null)) {
      try {
        String imageurl = await imageupload(imagefile!);
        UserCredential cred = await firbaseAuth11
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel model = UserModel(
            likes: [],
            share: [],
            email: email,
            followers: [],
            following: [],
            videos: [],
            bookmarked: [],
            userid: cred.user!.uid,
            username: username,
            photo: imageurl);

        await firstore
            .collection('users')
            .doc(cred.user!.uid)
            .set(model.tomap());
        Get.snackbar("success", 'completed');
      } catch (e) {
        Get.snackbar('Error happend', e.toString());
      }
    } else {
      Get.snackbar('null input', 'not completed fields');
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (email.isNotEmpty & password.isNotEmpty) {
      try {
        await firbaseAuth11.signInWithEmailAndPassword(
            email: email, password: password);
        Get.snackbar('success', 'you are loged in');
      } catch (err) {
        Get.snackbar('an error occured', err.toString());
      }
    } else {
      Get.snackbar('fields not completed ', 'complete the fields');
    }
  }
}

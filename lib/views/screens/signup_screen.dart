import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';

import '../../controllers/upload_controller.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({Key? key}) : super(key: key);

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
  }

  File? image;
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(30),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .15,
                      ),
                      // Flexible(
                      //   child:const SizedBox(),
                      //   flex: 2,
                      // ),
                      Text(
                        'Tik tok clone ',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: buttonColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Stack(
                        children: [
                          image != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(image!),
                                )
                              : const CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage(
                                      'assets/images/placeHolder1.png'),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () async {
                                  image = await UploadController.instance
                                      .showdialogforimagepick(
                                          context: context,
                                          media: _media,
                                          isvedio: false);

                                  setState(() {});
                                },
                                icon: const Icon(Icons.camera_alt,
                                    size: 30, color: Colors.blue)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Entet your email',
                            prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: usernamecontroller,
                        obscureText: false,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Username ',
                            prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: buttonColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7))),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width - 40, 50)),
                        onPressed: () async {
                          setState(() {
                            _isloading = true;
                          });
                          await AuthController.instance.regester(
                              password: passwordcontroller.text,
                              username: usernamecontroller.text,
                              email: emailcontroller.text,
                              imagefile: image);

                          setState(() {
                            _isloading = false;
                          });
                        },
                        child: _isloading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('ALready have an acoont? ',
                              style: TextStyle()),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: const Text('Log in',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ),
                          ),
                        ],
                      ),
                      // Flexible(
                      //   child:const SizedBox(),
                      //   flex: 2,
                      // ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

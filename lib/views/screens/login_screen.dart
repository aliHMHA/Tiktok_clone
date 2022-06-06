import 'package:flutter/material.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Flexible(
            child: SizedBox(),
            flex: 2,
          ),
          Text(
            'Tik tok clone',
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 35, color: buttonColor),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Log in',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
          ),
          const SizedBox(
            height: 25,
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
            controller: passwordcontroller,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entet your password ',
                prefixIcon: Icon(Icons.lock)),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: buttonColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                fixedSize: Size(MediaQuery.of(context).size.width - 40, 50)),
            onPressed: () async {
              setState(() {
                _isloading = true;
              });
              await AuthController.instance.login(
                  email: emailcontroller.text,
                  password: passwordcontroller.text);

              setState(() {
                _isloading = false;
              });
            },
            child: _isloading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Log in',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Dnt\'have an acoont? ', style: TextStyle()),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const SingupScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text('Sign up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ),
            ],
          ),
          const Flexible(
            child: SizedBox(),
            flex: 2,
          ),
        ]),
      ),
    );
  }
}

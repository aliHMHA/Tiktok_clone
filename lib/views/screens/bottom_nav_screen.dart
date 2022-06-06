import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/Add_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/home%20_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/profile_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/searsh_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/comments_scren.dart';
import 'package:tiktok_clone/views/widgets/custome_icone.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BottomNavScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    internitconiction();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    _pageController.dispose();
  }

  late StreamSubscription<ConnectivityResult> subscription;
  internitconiction() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          _isconnected = false;
        });
      } else {
        setState(() {
          _isconnected = true;
        });
      }
    });
  }

  bool _isconnected = true;

  changepage(int ind) {
    setState(() {
      _index = ind;
    });
  }

  ontapnavbar(int ind) {
    _pageController.jumpToPage(ind);
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return !_isconnected
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline_sharp,
                    size: 100,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'No internet connection',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'please check it.',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: PageView(
              children: [
                const HomeScreen(
                  videoid: null,
                  vidreoowneroid: null,
                ),
                const SearshScreen(),
                const AddScreen(),
                const CommentsScreen(
                  isPush: false,
                ),
                ProfileScreen(
                  profileOnerid: firbaseAuth11.currentUser!.uid,
                )
              ],
              onPageChanged: changepage,
              controller: _pageController,
            ),
            bottomNavigationBar: BottomNavigationBar(
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.grey,
                selectedLabelStyle: const TextStyle(color: Colors.white),
                unselectedLabelStyle: const TextStyle(color: Colors.white),
                backgroundColor: backgroundColor,
                onTap: ontapnavbar,
                items: [
                  BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: _index == 0 ? Colors.red : Colors.white,
                      )),
                  BottomNavigationBarItem(
                      label: 'Searsh',
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: _index == 1 ? Colors.red : Colors.white,
                      )),
                  const BottomNavigationBarItem(
                    label: '',
                    icon: CustomIcon(),
                  ),
                  BottomNavigationBarItem(
                      label: 'Comments',
                      icon: Icon(
                        Icons.message_outlined,
                        size: 30,
                        color: _index == 3 ? Colors.red : Colors.white,
                      )),
                  BottomNavigationBarItem(
                      label: 'Profile',
                      icon: Icon(
                        Icons.person,
                        size: 30,
                        color: _index == 4 ? Colors.red : Colors.white,
                      ))
                ]),
          );
  }
}

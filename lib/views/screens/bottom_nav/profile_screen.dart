import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:tiktok_clone/constrants.dart';

import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/models/vedio_model.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/home%20_screen.dart';
import 'package:tiktok_clone/views/screens/profile_pic_preview_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String profileOnerid;

  const ProfileScreen({Key? key, required this.profileOnerid})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    final ref = FirebaseFirestore.instance.collection('videos');

    _videomodelList = [];
    _isgetingdata = true;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileOnerid)
        .get();

    _profilowner = UserModel.fromesnap(snap);
    for (var element in _profilowner.videos) {
      final snap = await ref.doc(element).get();
      _videomodelList.add(VideoModel.fromesnap(snap));
    }
    _isCurrentAfowllower =
        _profilowner.followers.contains(FirebaseAuth.instance.currentUser!.uid);
    _followers = _profilowner.followers.length;
    _following = _profilowner.following.length;

    setState(() {
      _isgetingdata = false;
    });
  }

  followOrUnfolow(String yourUserid, String theOnetofollowid) async {
    try {
      final _firestore = FirebaseFirestore.instance;
      final snap =
          await _firestore.collection('users').doc(theOnetofollowid).get();
      UserModel theOnetofollow = UserModel.fromesnap(snap);
      if (theOnetofollow.followers.contains(yourUserid)) {
        _firestore.collection('users').doc(theOnetofollow.userid).update({
          'followers': FieldValue.arrayRemove([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayRemove([theOnetofollow.userid])
        });
      } else {
        _firestore.collection('users').doc(theOnetofollow.userid).update({
          'followers': FieldValue.arrayUnion([yourUserid])
        });
        _firestore.collection('users').doc(yourUserid).update({
          'following': FieldValue.arrayUnion([theOnetofollow.userid])
        });
      }
    } catch (e) {
      Get.snackbar('an error ocured', e.toString());
    }
  }

  bool _isgetingdata = true;
  List<VideoModel> _videomodelList = [];

  late UserModel _profilowner;
  late bool _isCurrentAfowllower;
  late int _followers;
  late int _following;
  @override
  Widget build(BuildContext context) {
    final uid = firbaseAuth11.currentUser!.uid;
    final _media = MediaQuery.of(context).size;
    final bool _iscurentuser = uid == widget.profileOnerid;
    // final _isWebScreen = _media.width > wepscreensize;

    return _isgetingdata
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            body: Container(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(
                    bottom: 18,
                    top: MediaQuery.of(context).viewPadding.top + 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ProfilPicPrevies(
                                imageurl: _profilowner.photo)));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 69,
                    child: CircleAvatar(
                      radius: 67,
                      backgroundColor: Colors.black,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(65),
                        child: CircleAvatar(
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    'assets/images/placeHolder2.jpg'),
                                image: NetworkImage(_profilowner.photo)),
                          ),
                          radius: 65,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    _profilowner.username,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: _media.width * .8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: _media.width * .26,
                            child: InfoColumn(
                              num: _profilowner.videos.length,
                              hhh: 'Videos',
                            ),
                          ),
                          SizedBox(
                            width: _media.width * .26,
                            child: InfoColumn(
                              num: _followers,
                              hhh: 'Followers',
                            ),
                          ),
                          SizedBox(
                            width: _media.width * .26,
                            child: InfoColumn(
                              num: _profilowner.likes.length,
                              hhh: 'Likes',
                            ),
                          ),
                        ],
                      ),
                    ),
                    _iscurentuser
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                fixedSize:
                                    Size(_media.width * .80, _media.width * .1),
                                onPrimary: Colors.white),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))
                        : SizedBox(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fixedSize: Size(
                                        _media.width * .80, _media.width * .1),
                                    primary: _isCurrentAfowllower
                                        ? Colors.white
                                        : Colors.blue),
                                onPressed: _isCurrentAfowllower
                                    ? () {
                                        followOrUnfolow(
                                            uid, widget.profileOnerid);
                                        setState(() {
                                          _followers--;
                                          _isCurrentAfowllower = false;
                                        });
                                      }
                                    : () {
                                        followOrUnfolow(
                                            uid, widget.profileOnerid);
                                        setState(() {
                                          _followers++;
                                          _isCurrentAfowllower = true;
                                        });
                                      },
                                child: _isCurrentAfowllower
                                    ? const Text(
                                        'Unfollow',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                      )
                                    : const Text(
                                        'Follow',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      )),
                          ),
                    const SizedBox(
                      height: 7,
                    )
                  ]),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        pattern: [
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 2),
                        ],
                      ),
                      itemCount: _videomodelList.length,
                      itemBuilder: (context, ind) {
                        return InkWell(
                            onTap: (() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return HomeScreen(
                                  vidreoowneroid: _videomodelList[ind].ownerid,
                                  videoid: _videomodelList[ind].videoid,
                                );
                              }));
                            }),
                            child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                    'assets/images/placeHolder3.jpg'),
                                image: NetworkImage(
                                    _videomodelList[ind].thumpnailurl)));
                      }))
            ]),
          ));
  }
}

class InfoColumn extends StatelessWidget {
  final String hhh;
  final int num;
  const InfoColumn({Key? key, required this.num, required this.hhh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            num.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            hhh,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

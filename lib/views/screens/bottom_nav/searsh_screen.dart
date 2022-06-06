import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/views/screens/bottom_nav/profile_screen.dart';

class SearshScreen extends StatefulWidget {
  const SearshScreen({Key? key}) : super(key: key);

  @override
  State<SearshScreen> createState() => _SearshScreenState();
}

class _SearshScreenState extends State<SearshScreen> {
  final _controller = TextEditingController();

  bool _isshowing = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    getuserid();
  }

  getuserid() async {
    _initialloading = true;
    final snap = await firstore
        .collection('users')
        .doc(firbaseAuth11.currentUser!.uid)
        .get();

    _user = UserModel.fromesnap(snap);
    setState(() {
      _initialloading = false;
    });
  }

  bool _initialloading = true;
  late UserModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
          style: const TextStyle(fontSize: 22),
          controller: _controller,
          decoration: const InputDecoration(
              hintStyle: TextStyle(fontSize: 22, color: Colors.blue),
              hintText: 'Searsh for users here.',
              border: InputBorder.none),
          onChanged: (ff) {
            if (ff.isEmpty) {
              _isshowing = false;
            } else {
              _isshowing = true;
            }
            setState(() {});
          },
        )),
        body: _initialloading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: _controller.text)
                    .get(),
                builder: (ctx,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    return _isshowing
                        ? ListView.builder(
                            itemCount: snap.data!.docs.length,
                            itemBuilder: ((context, index) {
                              UserModel _user =
                                  UserModel.fromesnap(snap.data!.docs[index]);
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (ctx) => ProfileScreen(
                                              profileOnerid: _user.userid,
                                            )),
                                  );
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(_user.photo),
                                          radius: 30,
                                        ),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _user.username,
                                            style:
                                                const TextStyle(fontSize: 25),
                                          ),
                                        ))
                                      ],
                                    )),
                              );
                            }))
                        : const Center(
                            child: Text(
                              'Searsh for users',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          );
                  }
                },
              ));
  }
}
// FutureBuilder(
//                       future:
//                           FirebaseFirestore.instance.collection('posts').get(),
//                       builder: (ctx,
//                           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                               snap) {
//                         if (!snap.hasData) {
//                           return const Center(
//                             child: Center(
//                                 child: CircularProgressIndicator(
//                                     color: primaryColor)),
//                           );
//                         }

//                         return GridView.builder(
//                             gridDelegate: SliverQuiltedGridDelegate(
//                               crossAxisCount: 4,
//                               mainAxisSpacing: 4,
//                               crossAxisSpacing: 4,
//                               repeatPattern: QuiltedGridRepeatPattern.inverted,
//                               pattern: [
//                                 const QuiltedGridTile(2, 2),
//                                 const QuiltedGridTile(1, 1),
//                                 const QuiltedGridTile(1, 1),
//                                 const QuiltedGridTile(1, 2),
//                               ],
//                             ),
//                             itemCount: snap.data!.docs.length,
//                             itemBuilder: (context, ind) {
//                               return Image.network(
//                                 snap.data!.docs[ind]['photoUrl'],
//                                 fit: BoxFit.cover,
//                               );
//                             });
//                       });
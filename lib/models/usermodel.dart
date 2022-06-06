import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String userid;
  String username;
  List followers;
  List following;
  List likes;
  List share;
  List videos;
  List bookmarked;
  String photo;

  UserModel(
      {required this.email,
      required this.followers,
      required this.following,
      required this.likes,
      required this.share,
      required this.videos,
      required this.bookmarked,
      required this.userid,
      required this.username,
      required this.photo});

  static UserModel fromjson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        followers: json['followers'],
        following: json['following'],
        likes: json['likes'],
        share: json['share'],
        videos: json['videos'],
        bookmarked: json['bookmarked'],
        userid: json['userid'],
        username: json['username'],
        photo: json['photo']);
  }

  static UserModel fromesnap(DocumentSnapshot snap) {
    var datta = snap.data() as Map<String, dynamic>;

    return UserModel(
        email: datta['email'],
        followers: datta['followers'],
        following: datta['following'],
        likes: datta['likes'],
        share: datta['share'],
        videos: datta['videos'],
        bookmarked: datta['bookmarked'],
        userid: datta['userid'],
        username: datta['username'],
        photo: datta['photo']);
  }

  Map<String, dynamic> tomap() {
    return {
      'email': email,
      'userid': userid,
      'username': username,
      'followers': followers,
      'following': following,
      'likes': likes,
      'share': share,
      'videos': videos,
      'bookmarked': bookmarked,
      'photo': photo
    };
  }
}

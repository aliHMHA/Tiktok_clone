import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:tiktok_clone/constrants.dart';
import 'package:tiktok_clone/models/vedio_model.dart';

class VideoController extends GetxController {
  static VideoController instance = Get.find();

  final Rx<List<VideoModel>> _videolist = Rx<List<VideoModel>>([]);

  List<VideoModel> get videolist => _videolist.value;

  @override
  void onInit() {
    super.onInit();
    _videolist.bindStream(
        firstore.collection('videos').snapshots().map((QuerySnapshot event) {
      List<VideoModel> rrr = [];
      for (var element in event.docs) {
        rrr.add(VideoModel.fromesnap(element));
      }
      return rrr;
    }));
  }

  VideoModel? _vedio;

  get vedio {
    return _vedio;
  }

  set currentvideo(VideoModel gg) {
    _vedio = gg;
  }
}

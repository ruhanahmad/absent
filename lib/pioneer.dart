import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';



class VideoEditingScreen extends StatefulWidget {
  @override
  _VideoEditingScreenState createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  // VideoPlayerController? _videoPlayerController;
  // GlobalKey _dragKey = GlobalKey();
  // double _left = 0;
  // double _top = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController = VideoPlayerController.network(
  //       'https://www.example.com/sample.mp4') // Replace with your video URL
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coming Soong'),
        automaticallyImplyLeading: false,
      ),
      body:
      Text("ASDASd")
      
  // @override
  // void dispose() {
  //   _videoPlayerController!.dispose();
  //   super.dispose();
  // }
    );
}
}
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  final String url;
  PhotoViewScreen({
    required this.url,
  });
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: PhotoView(
                disableGestures: false,
                enableRotation: true,
                filterQuality: FilterQuality.high,
                imageProvider: NetworkImage(
                  widget.url,
                ))));
  }
}

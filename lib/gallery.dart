import 'dart:io';
import 'package:flutter/material.dart';
import 'package:x_cam/db.dart';


class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> capturedImagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadPhotosFromDatabase();
  }

  Future<void> _loadPhotosFromDatabase() async {
    final dbHelper = PhotoDatabase();
    final photos = await dbHelper.getAllPhotos();
    setState(() {
      capturedImagePaths.addAll(photos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        backgroundColor: Colors.black,
      ),
      body: Gallery(imagePaths: capturedImagePaths),
    );
  }
}

class Gallery extends StatelessWidget {
  final List<String> imagePaths;

    Gallery({Key? key, required this.imagePaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Image.file(File(imagePaths[index]));
      },
    );
  }
}

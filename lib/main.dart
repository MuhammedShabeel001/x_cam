
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:x_cam/db.dart';
import 'package:x_cam/gallery.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)),
    debugShowCheckedModeBanner: false,
    home: CameraApp(camera: firstCamera),
  ));
}

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  CameraApp({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen(),));
          }, icon: Icon(Icons.image))
        ],
        title: Text('X cam'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
       
      Container(
        color: Colors.black,
        child: Center(
          
          child: Column(
            
            children: <Widget>[
              Expanded(
                
                child: CameraPreview(controller),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                    style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.circular(25)
                ),
                child: IconButton(onPressed: () async {
                    final image = await controller.takePicture();
                    final dbHelper = PhotoDatabase();
                    await dbHelper.insertPhoto(image.path);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(),
                      ),
                    );
                  }, icon: Icon(Icons.center_focus_strong,color: Colors.white,)),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}

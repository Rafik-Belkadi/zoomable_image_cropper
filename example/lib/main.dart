import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zoomable_image_cropper/zoomable_image_cropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoomable cropper Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ZoomableImageCropperController? controller;

  final boxHeight = 500.0;

  bool loadingImage = true;
  @override
  void initState() {
    getPermissionAndSelectImage().then((value) {
      Size size = MediaQuery.of(context).size;
      setState(() {
        controller = ZoomableImageCropperController(
            image: value.image,
            aspectRatio: value.aspectRatio,
            imageWidth: value.imageWidth,
            imageHeight: value.imageHeight,
            containerHeight: boxHeight,
            onInteractionUpdate: (details) {
              /* 
              *  You can use the details to get the scale and translation values
              *  to do something with it
              */
            },
            containerWidth: size.width);
        loadingImage = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zoomable cropper Demo'),
      ),
      body: SizedBox(
        height: size.height,
        child: Center(
            child: loadingImage
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: changeAspectRatio,
                          child: const Text('Change aspect ratio')),
                      ZoomableImageCropper(controller: controller!)
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bytes = await controller!.getCurrentCropImageBytes();
          // Use thes bytes to save the real file or send it to a server
          print(bytes);
        },
        child: const Icon(Icons.save_alt_outlined),
      ),
    );
  }

  Future<
      ({
        FileImage image,
        double aspectRatio,
        int imageWidth,
        int imageHeight
      })> getPermissionAndSelectImage() async {
    // I use photo manager to get the image from the gallery, but you can use any other method to get the image
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted != PermissionState.authorized) {
      throw Exception('Permission not granted');
    }
    final albums = await PhotoManager.getAssetPathList();
    final recentAlbum = albums.first;
    final recentAlbumAssets =
        await recentAlbum.getAssetListRange(start: 0, end: 5);
    final recentAsset = recentAlbumAssets.first;
    final file = await recentAsset.file;

    return (
      image: FileImage(file!),
      aspectRatio: recentAsset.width / recentAsset.height,
      imageWidth: recentAsset.width,
      imageHeight: recentAsset.height,
    );
  }

  changeAspectRatio() {
    // For the demo, I just change the aspect ratio randomly
    List<double> aspectRatios = [1.0, 16 / 12, 9 / 16];
    double randomAspectRatio = aspectRatios[Random().nextInt(3)];
    if (randomAspectRatio == controller?.aspectRatio) {
      changeAspectRatio();
      return;
    }
    setState(() {
      controller?.setAspectRatio(randomAspectRatio);
    });
  }
}

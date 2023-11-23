
# Zoomable Image Cropper for Flutter

![GitHub](https://img.shields.io/github/license/Rafik-Belkadi/zoomable_image_cropper)
![Pub Version](https://img.shields.io/pub/v/zoomable_image_cropper)
![GitHub stars](https://img.shields.io/github/stars/Rafik-Belkadi/zoomable_image_cropper?style=social)

Zoomable Image Cropper is a Flutter package that allows you to easily crop and zoom images with a user-friendly interface. It's perfect for use cases where you need to let users select and crop specific regions of an image.

![Demo](https://github.com/Rafik-Belkadi/zoomable_image_cropper/raw/main/demo.gif)

## Features

- **Zoom In and Out:** Users can zoom in and out to get a better view of the image.
- **Draggable Crop Area:** The crop area can be moved around to select the desired cropping region.
- **Customizable:** You can customize various aspects of the cropper, such as aspect ratio, overlay color, and more.
- **Easy to Use:** The package provides a simple API for integrating the cropper into your Flutter app.

## Installation

To use this package, add `zoomable_image_cropper` as a dependency in your `pubspec.yaml` file.

```yaml {"id":"01HFYCWDYKMDB9PTM57AH95GFR"}
dependencies:
  zoomable_image_cropper: ^0.1.0 # Use the latest version from pub.dev
```

Then, import the package in your Dart code:

```dart {"id":"01HFYCWDYKMDB9PTM57BYRFW2F"}
import 'package:zoomable_image_cropper/zoomable_image_cropper.dart';
```

## Usage

Here's a basic example of how to use the Zoomable Image Cropper in your Flutter app:

```dart {"id":"01HFYCWDYKMDB9PTM57E0RC9D0"}
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
        title: const Text('Zoomable cropper Demo'),
      ),
      body: SizedBox(
        height: size.height,
        child: Center(
            child: loadingImage
                ? const CircularProgressIndicator()
                : ZoomableImageCropper(controller: controller!)
        ),
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
}

```

## Contributing

Contributions are welcome! If you encounter any issues or have ideas for improvements, please open an issue on the GitHub repository. If you'd like to contribute code, please follow the contribution guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Rafik-Belkadi/zoomable_image_cropper/blob/main/LICENSE) file for details.

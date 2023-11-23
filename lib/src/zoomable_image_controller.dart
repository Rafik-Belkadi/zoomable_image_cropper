import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'media_transformations.dart';

import 'package:native_image_cropper/native_image_cropper.dart';

/// Controller for the ZoomableImageCropper widget.
///
/// This controller manages the transformation and cropping of the image.
/// It provides methods to set the media transformer, aspect ratio, and retrieve the cropped image bytes.
class ZoomableImageCropperController {
  final TransformationController transformationController =
      TransformationController();
  late MediaTransformer mediaTransformer;

  final FileImage image;
  double aspectRatio;
  final int imageWidth;
  final int imageHeight;
  final double containerHeight;
  final double containerWidth;
  final bool showResizeGrid;
  final void Function(ScaleUpdateDetails)? onInteractionUpdate;
  StreamController<bool> showGrid$ = StreamController<bool>.broadcast();

  /// Creates a new ZoomableImageCropperController instance.
  ///
  /// The [image] parameter is the FileImage to be cropped.
  /// The [aspectRatio] parameter specifies the desired aspect ratio for cropping.
  /// The [imageWidth] and [imageHeight] parameters specify the original dimensions of the image.
  /// The [containerHeight] and [containerWidth] parameters specify the dimensions of the image container.
  /// The [showResizeGrid] parameter determines whether to show the resize grid.
  /// The [onInteractionUpdate] parameter is a callback function that is called when the image is interacted with.
  ZoomableImageCropperController({
    required this.image,
    required this.aspectRatio,
    required this.imageWidth,
    required this.imageHeight,
    required this.containerHeight,
    required this.containerWidth,
    this.onInteractionUpdate,
    this.showResizeGrid = true,
  }) {
    mediaTransformer = MediaTransformer(
        imageAspectRatio: aspectRatio,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        imageContainerSize: Size(containerWidth, containerHeight));

    transformationController.value = Matrix4.identity()
      ..scale(mediaTransformer.getInitialScale());
  }

  /// Sets the media transformer for the controller.
  ///
  /// The [mediaTransformer] parameter is the new media transformer to be set.
  setMediaTransformer(MediaTransformer mediaTransformer) {
    this.mediaTransformer = mediaTransformer;
  }

  /// Sets the aspect ratio for cropping.
  ///
  /// The [aspectRatio] parameter specifies the new aspect ratio to be set.
  setAspectRatio(double aspectRatio) {
    this.aspectRatio = aspectRatio;

    mediaTransformer.imageAspectRatio = aspectRatio;

    double initialScale = mediaTransformer.getInitialScale();

    transformationController.value = Matrix4.identity()..scale(initialScale);
  }

  /// Retrieves the bytes of the current cropped image.
  ///
  /// This method returns a Future that completes with the bytes of the cropped image.
  Future<Uint8List> getCurrentCropImageBytes() async {
    final bytes = await image.file.readAsBytes();
    final transformations =
        mediaTransformer.getImageTransformations(transformationController);
    final croppedBytes = await NativeImageCropper.cropRect(
        bytes: bytes,
        x: transformations.cropPosition.left.toInt(),
        y: transformations.cropPosition.top.toInt(),
        width: transformations.width.toInt(),
        height: transformations.height.toInt(),
        format: ImageFormat.jpg);
    return croppedBytes;
  }
}

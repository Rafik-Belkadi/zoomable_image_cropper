import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// A typedef representing the transformations applied to media.
///
/// The [aspectRatio] represents the aspect ratio of the media.
/// The [cropPosition] represents the position of the crop.
/// The [width] represents the width of the media.
/// The [height] represents the height of the media.
typedef Transformations = ({
  double aspectRatio,
  ({double left, double top}) cropPosition,
  num width,
  num height
});

/// A class that performs transformations on media.
class MediaTransformer {
  double imageAspectRatio;
  final int imageWidth;
  final int imageHeight;
  final Size imageContainerSize;

  /// Constructs a [MediaTransformer] instance.
  ///
  /// The [imageAspectRatio] represents the aspect ratio of the image.
  /// The [imageWidth] represents the width of the image.
  /// The [imageHeight] represents the height of the image.
  /// The [imageContainerSize] represents the size of the image container.
  MediaTransformer({
    required this.imageAspectRatio,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageContainerSize,
  });

  /// Returns the size of the image container for initial scaling.
  ///
  /// The [biggerSide] represents the bigger side of the image.
  double getImageContainerSizeForInitialScaling(String biggerSide) {
    Size displayedImageSize =
        getDisplayedImageSizeFromAspectRatio(imageAspectRatio);
    if (imageAspectRatio > 1) {
      return displayedImageSize.width;
    }
    if (imageAspectRatio < 1) {
      return displayedImageSize.height;
    }
    return biggerSide == 'width'
        ? displayedImageSize.height
        : displayedImageSize.width;
  }

  /// Returns the bigger side of the image.
  String getBiggerSide() {
    return imageWidth > imageHeight ? 'width' : 'height';
  }

  /// Returns the original media size for initial scaling.
  ///
  /// The [biggerSide] represents the bigger side of the image.
  int getOriginalMediaSizeForInitialScale(String biggerSide) {
    if (imageAspectRatio > 1) {
      return imageWidth;
    }

    if (imageAspectRatio < 1) {
      return imageHeight;
    }

    return biggerSide == 'width' ? imageHeight : imageWidth;
  }

  /// Returns the displayed image size from the aspect ratio.
  ///
  /// The [aspectRatio] represents the aspect ratio of the image.
  Size getDisplayedImageSizeFromAspectRatio(double aspectRatio) {
    Size size;
    if (aspectRatio > 1) {
      size = Size(
        imageContainerSize.width,
        imageContainerSize.width / aspectRatio,
      );
    } else if (aspectRatio == 1) {
      size = Size(
        imageContainerSize.height,
        imageContainerSize.height,
      );
    } else {
      size = Size(
        imageContainerSize.height * aspectRatio,
        imageContainerSize.height,
      );
    }
    return size;
  }

  /// Returns the initial scale for the image.
  double getInitialScale() {
    String biggerSide = getBiggerSide();
    double size = getImageContainerSizeForInitialScaling(biggerSide);
    int originalSize = getOriginalMediaSizeForInitialScale(biggerSide);
    double initialScale = size / originalSize;

    return initialScale;
  }

  /// Returns the image transformations based on the transformation controller.
  ///
  /// The [transformationController] represents the transformation controller.
  Transformations getImageTransformations(
      TransformationController transformationController) {
    // Extract the scale and translation components from the matrix
    Matrix4 transformMatrix = transformationController.value;
    double scale = transformMatrix.getMaxScaleOnAxis();
    Vector3 translation = transformMatrix.getTranslation();

    // Get the actual dimensions of the original image and the displayed image
    double originalImageWidth = imageWidth.toDouble();
    double originalImageHeight = imageHeight.toDouble();

    Size displayedImageSize =
        getDisplayedImageSizeFromAspectRatio(imageAspectRatio);

    double displayedImageWidth = displayedImageSize.width;
    double displayedImageHeight = displayedImageSize.height;

    double boxRatio = displayedImageWidth / displayedImageHeight;

    if (boxRatio <= 0.8) {
      boxRatio = 0.8;
    }

    double left = (translation.x.abs() < 10 ? 0 : translation.x.abs()) / scale;
    double top = (translation.y.abs() < 10 ? 0 : translation.y.abs()) / scale;

    double initialScale = getInitialScale();
    double scaleFactor = scale / initialScale;
    double originalScaleFactor = originalImageWidth / displayedImageWidth;

    double width = (displayedImageWidth * originalScaleFactor) / scaleFactor;
    double height = (displayedImageHeight * originalScaleFactor) / scaleFactor;

    return (
      aspectRatio: imageAspectRatio,
      cropPosition: (left: left, top: top),
      width: width.floor() >= originalImageWidth - left.floor()
          ? (originalImageWidth.toInt() - left.floor() - 1)
          : width.floor(),
      height: (height.floor() >= originalImageHeight - top.floor()
          ? (originalImageHeight.toInt() - top.floor() - 1)
          : height.floor()),
    );
  }
}

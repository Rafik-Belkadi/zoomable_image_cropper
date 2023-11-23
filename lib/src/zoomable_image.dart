import 'package:zoomable_image_cropper/src/zoomable_image_controller.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final ZoomableImageCropperController controller;

  const ZoomableImage({super.key, required this.controller});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.controller.containerHeight,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: AspectRatio(
            aspectRatio: widget.controller.aspectRatio,
            child: InteractiveViewer(
              onInteractionUpdate: (details) {
                widget.controller.onInteractionUpdate?.call(details);
                if (widget.controller.showResizeGrid) {
                  widget.controller.showGrid$.add(true);
                }
              },
              constrained: false,
              transformationController:
                  widget.controller.transformationController,
              minScale: 0.1,
              maxScale: 4.0,
              scaleEnabled: true,
              panEnabled: true,
              child: Image(
                image: widget.controller.image,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ));
  }
}

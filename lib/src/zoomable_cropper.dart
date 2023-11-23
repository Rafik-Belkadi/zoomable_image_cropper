import 'package:flutter/material.dart';

import 'container_grid_lines.dart';
import 'zoomable_image.dart';
import 'zoomable_image_controller.dart';

class ZoomableImageCropper extends StatefulWidget {
  final ZoomableImageCropperController controller;

  const ZoomableImageCropper({
    super.key,
    required this.controller,
  });

  @override
  State<ZoomableImageCropper> createState() => _ZoomableImageCropperState();
}

class _ZoomableImageCropperState extends State<ZoomableImageCropper> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.controller.containerHeight,
      child: Stack(
        children: [
          ZoomableImage(
            controller: widget.controller,
          ),
          if (widget.controller.showResizeGrid)
            IgnorePointer(
              ignoring: true,
              child: ContainerGridLines(
                showGrid$: widget.controller.showGrid$,
                containerHeight: widget.controller.containerHeight,
                containerWidth: widget.controller.containerWidth,
              ),
            )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that displays grid lines within a container.
///
/// The [ContainerGridLines] widget is used to show grid lines within a container.
/// It takes a [showGrid$] stream controller, [containerHeight], and [containerWidth] as parameters.
/// The [showGrid$] stream controller is used to control the visibility of the grid lines.
/// The [containerHeight] and [containerWidth] specify the dimensions of the container.
///
/// Example usage:
/// ```dart
/// ContainerGridLines(
///   showGrid$: _showGridController,
///   containerHeight: 200,
///   containerWidth: 200,
/// )
/// ```
class ContainerGridLines extends StatefulWidget {
  final StreamController<bool> showGrid$;
  final double containerHeight;
  final double containerWidth;

  /// Creates a [ContainerGridLines] widget.
  ///
  /// The [showGrid$] stream controller is used to control the visibility of the grid lines.
  /// The [containerHeight] and [containerWidth] specify the dimensions of the container.
  const ContainerGridLines({
    super.key,
    required this.showGrid$,
    required this.containerHeight,
    required this.containerWidth,
  });

  @override
  State<ContainerGridLines> createState() => _ContainerGridLinesState();
}

class _ContainerGridLinesState extends State<ContainerGridLines> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: StreamBuilder<bool>(
        stream: widget.showGrid$.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return const SizedBox();
          }
          return Animate(
            onComplete: (_) {
              widget.showGrid$.add(false);
            },
            child: SizedBox(
              height: widget.containerHeight,
              width: widget.containerWidth,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                  );
                },
              ),
            ),
          ).fadeOut(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 4000),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}

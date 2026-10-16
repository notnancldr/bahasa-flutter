import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const ShapeLoadingPreviewApp());
}

/// A minimal demo app to preview the [ShapeLoading] component.
class ShapeLoadingPreviewApp extends StatelessWidget {
  const ShapeLoadingPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        backgroundColor: Color(0xFF12131A),
        body: Center(child: ShapeLoading()),
      ),
    );
  }
}

/// A 2x2 grid loading indicator that animates 4 SVG shapes in a clockwise
/// sequence:
///   1  2
///   4  3
///
/// Each shape performs the following sequence before the next shape starts:
///   1. Scale up (`1.0` -> [scaleFactor])
///   2. Rotate 90 degrees (`0.25` turns)
///   3. Scale down back to the original scale ([scaleFactor] -> `1.0`)
class ShapeLoading extends StatelessWidget {
  const ShapeLoading({
    super.key,
    this.shapeSize = 48.0,
    this.spacing = 16.0,
    this.scaleFactor = 1.25,
    this.stepDuration = const Duration(milliseconds: 220),
    this.curve = Curves.easeInOutCubic,
    this.color,
  });

  /// Width and height of each individual SVG shape.
  final double shapeSize;

  /// Horizontal and vertical gap between shapes in the 2x2 grid.
  final double spacing;

  /// Target scale multiplier reached during the "scale up" phase.
  final double scaleFactor;

  /// Duration of each individual phase (scale up, rotate 90deg, scale down).
  final Duration stepDuration;

  /// Easing curve applied to each phase of the animation.
  final Curve curve;

  /// Fill color applied to the SVG shapes via [_ShapeLoadingColorMapper].
  final Color? color;

  static const _shapes = [
    """
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M83.3624 21.5934C88.6304 12.8022 101.37 12.8022 106.638 21.5934L112.562 31.4799C115.634 36.6068 121.7 39.1192 127.497 37.6663L138.677 34.8647C148.619 32.3734 157.627 41.3813 155.135 51.3227L152.334 62.5026C150.881 68.3003 153.393 74.3659 158.52 77.4381L168.407 83.3624C177.198 88.6304 177.198 101.37 168.407 106.638L158.52 112.562C153.393 115.634 150.881 121.7 152.334 127.497L155.135 138.677C157.627 148.619 148.619 157.627 138.677 155.135L127.497 152.334C121.7 150.881 115.634 153.393 112.562 158.52L106.638 168.407C101.37 177.198 88.6304 177.198 83.3624 168.407L77.4381 158.52C74.3659 153.393 68.3003 150.881 62.5026 152.334L51.3228 155.135C41.3814 157.627 32.3734 148.619 34.8647 138.677L37.6663 127.497C39.1192 121.7 36.6068 115.634 31.4799 112.562L21.5934 106.638C12.8022 101.37 12.8022 88.6304 21.5934 83.3624L31.4798 77.4381C36.6068 74.3659 39.1192 68.3003 37.6663 62.5026L34.8647 51.3228C32.3734 41.3814 41.3813 32.3734 51.3227 34.8647L62.5026 37.6663C68.3003 39.1192 74.3659 36.6068 77.4381 31.4799L83.3624 21.5934Z" fill="#FFFFFF"/>
    </svg>
    """,
    """
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M77.5321 24.7295C88.0467 17.0902 102.285 17.0902 112.799 24.7295L161.463 60.0857C171.977 67.725 176.377 81.266 172.361 93.6267L153.773 150.834C149.757 163.195 138.238 171.564 125.241 171.564H65.0899C52.0931 171.564 40.5744 163.195 36.5582 150.834L17.9704 93.6267C13.9541 81.266 18.3539 67.725 28.8685 60.0857L77.5321 24.7295Z" fill="#FFFFFF"/>
    </svg>
    """,
    """
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M83.3484 19.9229C83.6189 19.6578 83.7542 19.5253 83.8714 19.4149C90.1228 13.5284 99.8772 13.5284 106.129 19.4149C106.246 19.5253 106.381 19.6578 106.652 19.9229C106.814 20.082 106.895 20.1615 106.972 20.2351C110.973 24.0528 116.641 25.5716 122.014 24.2656C122.118 24.2404 122.228 24.2121 122.448 24.1555C122.815 24.0612 122.998 24.0141 123.155 23.9771C131.512 22.0049 139.96 26.8821 142.43 35.1057C142.477 35.2599 142.527 35.4423 142.629 35.8072C142.69 36.0261 142.721 36.1355 142.751 36.2379C144.306 41.5442 148.456 45.6938 153.762 47.2492C153.864 47.2792 153.974 47.3098 154.193 47.3708C154.558 47.4726 154.74 47.5235 154.894 47.5698C163.118 50.0404 167.995 58.488 166.023 66.8451C165.986 67.0019 165.939 67.1853 165.845 67.5521C165.788 67.7722 165.76 67.8823 165.734 67.9859C164.428 73.359 165.947 79.0275 169.765 83.0277C169.839 83.1048 169.918 83.186 170.077 83.3484C170.342 83.6189 170.475 83.7542 170.585 83.8714C176.472 90.1228 176.472 99.8772 170.585 106.129C170.475 106.246 170.342 106.381 170.077 106.652C169.918 106.814 169.839 106.895 169.765 106.972C165.947 110.973 164.428 116.641 165.734 122.014C165.76 122.118 165.788 122.228 165.845 122.448C165.939 122.815 165.986 122.998 166.023 123.155C167.995 131.512 163.118 139.96 154.894 142.43C154.74 142.477 154.558 142.527 154.193 142.629C153.974 142.69 153.864 142.721 153.762 142.751C148.456 144.306 144.306 148.456 142.751 153.762C142.721 153.864 142.69 153.974 142.629 154.193C142.527 154.558 142.477 154.74 142.43 154.894C139.96 163.118 131.512 167.995 123.155 166.023C122.998 165.986 122.815 165.939 122.448 165.845C122.228 165.788 122.118 165.76 122.014 165.734C116.641 164.428 110.973 165.947 106.972 169.765C106.895 169.839 106.814 169.918 106.652 170.077C106.381 170.342 106.246 170.475 106.129 170.585C99.8772 176.472 90.1228 176.472 83.8714 170.585C83.7542 170.475 83.6189 170.342 83.3484 170.077C83.186 169.918 83.1048 169.839 83.0277 169.765C79.0275 165.947 73.359 164.428 67.9859 165.734C67.8823 165.76 67.7722 165.788 67.5521 165.845C67.1853 165.939 67.0019 165.986 66.8451 166.023C58.488 167.995 50.0404 163.118 47.5698 154.894C47.5235 154.74 47.4726 154.558 47.3708 154.193C47.3098 153.974 47.2792 153.864 47.2492 153.762C45.6938 148.456 41.5442 144.306 36.2379 142.751C36.1355 142.721 36.0261 142.69 35.8072 142.629C35.4423 142.527 35.2599 142.477 35.1057 142.43C26.8821 139.96 22.0049 131.512 23.9771 123.155C24.0141 122.998 24.0612 122.815 24.1555 122.448C24.2121 122.228 24.2404 122.118 24.2656 122.014C25.5716 116.641 24.0528 110.973 20.2351 106.972C20.1615 106.895 20.082 106.814 19.9229 106.652C19.6578 106.381 19.5253 106.246 19.4149 106.129C13.5284 99.8772 13.5284 90.1228 19.4149 83.8714C19.5253 83.7542 19.6578 83.6189 19.9229 83.3484C20.082 83.186 20.1615 83.1048 20.2351 83.0277C24.0528 79.0275 25.5716 73.359 24.2656 67.9859C24.2404 67.8823 24.2121 67.7722 24.1555 67.5521C24.0612 67.1853 24.0141 67.0019 23.9771 66.8451C22.0049 58.488 26.8821 50.0404 35.1057 47.5698C35.2599 47.5235 35.4423 47.4726 35.8072 47.3708C36.0261 47.3098 36.1355 47.2792 36.2379 47.2492C41.5442 45.6937 45.6937 41.5442 47.2492 36.2379C47.2792 36.1355 47.3098 36.0261 47.3708 35.8072C47.4726 35.4423 47.5235 35.2599 47.5698 35.1057C50.0404 26.8821 58.488 22.0049 66.8451 23.9771C67.0019 24.0141 67.1853 24.0612 67.5521 24.1555C67.7722 24.2121 67.8823 24.2404 67.9859 24.2656C73.359 25.5716 79.0275 24.0528 83.0277 20.2351C83.1048 20.1615 83.186 20.082 83.3484 19.9229Z" fill="#FFFFFF"/>
    </svg>
    """,
    """
    <svg width="190" height="190" viewBox="0 0 190 190" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M58.0578 35.8925C84.5812 9.36916 127.584 9.36916 154.107 35.8925C180.631 62.4159 180.631 105.419 154.107 131.942L131.942 154.107C105.419 180.631 62.4159 180.631 35.8925 154.107C9.36916 127.584 9.36915 84.5812 35.8925 58.0578L58.0578 35.8925Z" fill="#FFFFFF"/>
    </svg>
    """,
  ];

  /// Builds an individual SVG shape animated at its assigned [sequenceIndex]
  /// (`0` = 1st, `1` = 2nd, `2` = 3rd, `3` = 4th).
  Widget _buildAnimatedShape(
    BuildContext context, {
    required String svgData,
    required int sequenceIndex,
  }) {
    final WidgetVars(:c) = WidgetVars.of(context);

    // Each shape's active animation has 3 phases: scale up, rotate 90deg, scale down.
    final singleShapeDuration = stepDuration * 3;

    // Delay before this shape starts its turn in the 1 -> 2 -> 3 -> 4 sequence.
    final initialDelay = singleShapeDuration * sequenceIndex;

    // Remaining time after this shape finishes so all 4 controllers share
    // the exact same total cycle duration (singleShapeDuration * 4).
    final remainingDelay = singleShapeDuration * (3 - sequenceIndex);

    return SvgPicture.string(
          svgData,
          width: shapeSize,
          height: shapeSize,
          colorMapper: _ShapeLoadingColorMapper(color: color ?? c.primary),
        )
        .animate(onPlay: (controller) => controller.repeat())
        // Phase 1: Scale up from 1.0 to scaleFactor
        .scaleXY(
          delay: initialDelay,
          duration: stepDuration,
          begin: 1.0,
          end: scaleFactor,
          curve: curve,
          alignment: Alignment.center,
        )
        // Phase 2: Rotate 90 degrees (0.25 turns) while holding scaled size
        .then()
        .rotate(
          duration: stepDuration,
          begin: 0.0,
          end: 0.25,
          curve: curve,
          alignment: Alignment.center,
        )
        // Phase 3: Scale back down to the original 1.0 scale
        // (1.0 / scaleFactor multiplies with Phase 1's scaleFactor to return to 1.0)
        .then()
        .scaleXY(
          duration: stepDuration,
          begin: 1.0,
          end: 1.0 / scaleFactor,
          curve: curve,
          alignment: Alignment.center,
        )
        // Pad the end of the timeline so every shape loops on the full 4-shape cycle
        .then()
        .custom(
          duration: remainingDelay,
          builder: (context, value, child) => child,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row: 1 (sequenceIndex: 0), 2 (sequenceIndex: 1)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedShape(
              context,
              svgData: _shapes[0],
              sequenceIndex: 0, // 1st
            ),
            SizedBox(width: spacing),
            _buildAnimatedShape(
              context,
              svgData: _shapes[1],
              sequenceIndex: 1, // 2nd
            ),
          ],
        ),
        SizedBox(height: spacing),
        // Bottom row: 4 (sequenceIndex: 3), 3 (sequenceIndex: 2)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedShape(
              context,
              svgData: _shapes[3],
              sequenceIndex: 3, // 4th
            ),
            SizedBox(width: spacing),
            _buildAnimatedShape(
              context,
              svgData: _shapes[2],
              sequenceIndex: 2, // 3rd
            ),
          ],
        ),
      ],
    );
  }
}

class _ShapeLoadingColorMapper extends ColorMapper {
  final Color color;
  const _ShapeLoadingColorMapper({required this.color});

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    return this.color;
  }
}

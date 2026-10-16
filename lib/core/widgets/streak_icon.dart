import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Accuracy

/// Accuracy icon widget rendered in vibrant colors or grayscale (when streak is 0).
class AccuracyIcon extends StatelessWidget {
  /// The size (both width and height) of the Accuracy icon.
  final double size;

  const AccuracyIcon({super.key, this.size = 180});

  static const _vibrantSvg = """
    <svg width="41" height="41" viewBox="0 0 41 41" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M2 20.235C2 30.2992 10.1708 38.47 20.235 38.47C30.2992 38.47 38.47 30.2992 38.47 20.235C38.47 10.1708 30.2992 2 20.235 2C10.1708 2 2 10.1708 2 20.235Z" stroke="#A9D6E5" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M9.294 20.235C9.294 26.2735 14.1965 31.176 20.235 31.176C26.2735 31.176 31.176 26.2735 31.176 20.235C31.176 14.1965 26.2735 9.294 20.235 9.294C14.1965 9.294 9.294 14.1965 9.294 20.235Z" stroke="#A9D6E5" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M16.588 20.235C16.588 22.2478 18.2222 23.882 20.235 23.882C22.2478 23.882 23.882 22.2478 23.882 20.235C23.882 18.2222 22.2478 16.588 20.235 16.588C18.2222 16.588 16.588 18.2222 16.588 20.235Z" stroke="#A9D6E5" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M2 20.235C2 30.2992 10.1708 38.47 20.235 38.47C30.2992 38.47 38.47 30.2992 38.47 20.235C38.47 10.1708 30.2992 2 20.235 2M9.294 20.235C9.294 26.2735 14.1965 31.176 20.235 31.176C26.2735 31.176 31.176 26.2735 31.176 20.235C31.176 14.1965 26.2735 9.294 20.235 9.294M16.588 20.235C16.588 22.2478 18.2222 23.882 20.235 23.882C22.2478 23.882 23.882 22.2478 23.882 20.235C23.882 18.2222 22.2478 16.588 20.235 16.588C18.2222 16.588 16.588 18.2222 16.588 20.235Z" stroke="#5B93AE" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  """;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_vibrantSvg, width: size, height: size);
  }
}

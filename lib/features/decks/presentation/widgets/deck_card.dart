import 'dart:async';

import 'package:bahasa/core/theme/app_colors.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../domain/entities/deck_item.dart';
import '../utils/flag_palette_color_cache.dart';

/// Custom notched card displaying a flashcard deck in the 2-column compilation grid.
///
/// Extracts the dominant color from the rendered [CountryFlag] using
/// `palette_generator_master` and seeds a [ColorScheme] to determine its
/// primary background color.
class DeckCard extends StatefulWidget {
  /// The deck item to display.
  final DeckItem deck;

  /// Whether the parent page is currently in multi-selection mode.
  final bool isSelectionMode;

  /// Whether this specific deck card is currently selected.
  final bool isSelected;

  /// Callback invoked when the card is tapped.
  final VoidCallback onTap;

  /// Callback invoked when the card is long-pressed.
  final VoidCallback onLongPress;

  /// Creates a [DeckCard].
  const DeckCard({
    super.key,
    required this.deck,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<DeckCard> createState() => _DeckCardState();
}

class _DeckCardState extends State<DeckCard> {
  final GlobalKey _flagBoundaryKey = GlobalKey();
  Color? _seededPrimaryColor;
  Timer? _retryTimer;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _seededPrimaryColor = FlagPaletteColorCache.getCachedColor(
      widget.deck.language,
    );
    if (_seededPrimaryColor == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _extractFlagColor());
    }
  }

  @override
  void didUpdateWidget(covariant DeckCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deck.language != widget.deck.language) {
      _attempts = 0;
      _retryTimer?.cancel();
      _seededPrimaryColor = FlagPaletteColorCache.getCachedColor(
        widget.deck.language,
      );
      if (_seededPrimaryColor == null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _extractFlagColor(),
        );
      }
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> _extractFlagColor() async {
    if (!mounted) return;

    final cached = FlagPaletteColorCache.getCachedColor(widget.deck.language);
    if (cached != null) {
      setState(() => _seededPrimaryColor = cached);
      return;
    }

    try {
      final renderObject = _flagBoundaryKey.currentContext?.findRenderObject();
      if (renderObject is RenderRepaintBoundary &&
          renderObject.hasSize &&
          !renderObject.size.isEmpty) {
        final image = await renderObject.toImage(pixelRatio: 1.0);
        try {
          final color =
              await FlagPaletteColorCache.extractPrimaryColorFromImage(
                image,
                languageCode: widget.deck.language,
              );
          if (color != null && mounted) {
            setState(() => _seededPrimaryColor = color);
            return;
          }
        } finally {
          image.dispose();
        }
      }
    } catch (_) {
      // Ignore transient capture errors before first paint completes
    }

    // Retry a few times in case the SVG asset inside CountryFlag is still loading
    if (mounted && _attempts < 5) {
      _attempts++;
      _retryTimer = Timer(const Duration(milliseconds: 60), _extractFlagColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:t) = WidgetVars.of(context);
    final baseColor =
        _seededPrimaryColor ?? FlagPaletteColorCache.defaultCardColor;
    final cardColor = FlagPaletteColorCache.resolveCardBackgroundColor(
      baseColor,
      isSelected: widget.isSelected,
    );

    return AnimatedScale(
      scale: widget.isSelected ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = constraints.maxHeight;
          final notchCenterY = cardHeight * 0.55;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Notched card body
              Positioned.fill(
                child: ClipPath(
                  clipper: const _NotchedDeckCardClipper(),
                  child: Material(
                    color: cardColor,
                    child: InkWell(
                      onTap: widget.onTap,
                      onLongPress: widget.onLongPress,
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 16, 24, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Country flag wrapped in RepaintBoundary for palette extraction
                            RepaintBoundary(
                              key: _flagBoundaryKey,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CountryFlag.fromLanguageCode(
                                  widget.deck.language,
                                  theme: const ImageTheme(
                                    width: 68,
                                    height: 44,
                                    shape: RoundedRectangle(8),
                                  ),
                                ),
                              ),
                            ),

                            // Deck title at bottom-left
                            Text(
                              widget.deck.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Chevron icon positioned inside the right-edge concave notch
              Positioned(
                right: 0,
                top: notchCenterY - 11,
                child: IgnorePointer(
                  child: Icon(
                    Symbols.chevron_right,
                    size: 22,
                    weight: 700,
                    color: cardColor,
                  ),
                ),
              ),

              // Selection checkbox in top-right corner when in selection mode
              if (widget.isSelectionMode)
                Positioned(
                  top: 10,
                  right: 10,
                  child: IgnorePointer(
                    child: _SelectionCheckbox(isSelected: widget.isSelected),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SelectionCheckbox extends StatelessWidget {
  final bool isSelected;

  const _SelectionCheckbox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
        border: isSelected ? null : Border.all(color: Colors.white, width: 1.5),
      ),
      child: isSelected
          ? const Icon(
              Symbols.check,
              size: 18,
              weight: 700,
              color: AppColors.mainText,
            )
          : null,
    );
  }
}

/// Clips a rounded rectangle with a smooth inward concave notch along the right edge.
class _NotchedDeckCardClipper extends CustomClipper<Path> {
  const _NotchedDeckCardClipper();

  @override
  Path getClip(Size size) {
    const cornerRadius = 18.0;
    const notchDepth = 22.0;
    const notchHalfSpan = 34.0;

    final w = size.width;
    final h = size.height;
    final cy = h * 0.55;
    final notchTop = cy - notchHalfSpan;
    final notchBottom = cy + notchHalfSpan;

    final path = Path()
      ..moveTo(cornerRadius, 0)
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(
        Offset(w, cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(w, notchTop)
      // Smooth S-curve into the concave notch apex
      ..cubicTo(w, notchTop + 14, w - notchDepth, cy - 18, w - notchDepth, cy)
      // Smooth S-curve back out to the right edge
      ..cubicTo(w - notchDepth, cy + 18, w, notchBottom - 14, w, notchBottom)
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(
        Offset(w - cornerRadius, h),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(cornerRadius, h)
      ..arcToPoint(
        Offset(0, h - cornerRadius),
        radius: const Radius.circular(cornerRadius),
      )
      ..lineTo(0, cornerRadius)
      ..arcToPoint(
        const Offset(cornerRadius, 0),
        radius: const Radius.circular(cornerRadius),
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

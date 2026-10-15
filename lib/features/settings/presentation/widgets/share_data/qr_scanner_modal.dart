import 'package:bahasa/core/utils/widget_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Modal bottom sheet providing a camera scanner for transfer QR codes.
class QrScannerModal extends StatefulWidget {
  const QrScannerModal({super.key});

  /// Displays the [QrScannerModal] bottom sheet, returning the scanned string or null if dismissed.
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => const QrScannerModal(),
    );
  }

  @override
  State<QrScannerModal> createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal> {
  late final MobileScannerController _controller;
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final code = barcodes.first.rawValue;
      if (code != null && code.trim().isNotEmpty) {
        _isScanned = true;
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(code.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final size = MediaQuery.of(context).size;
    final scannerHeight = (size.height * 0.65).clamp(360.0, 520.0);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header row
          Row(
            children: [
              Icon(Symbols.qr_code_scanner, color: c.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                l.shareData_scanner_title,
                style: t.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: c.onSurface,
                ),
              ),
              const Spacer(),

              // Torch button
              ValueListenableBuilder<MobileScannerState>(
                valueListenable: _controller,
                builder: (context, state, _) {
                  if (!state.isInitialized || !state.isRunning) {
                    return const SizedBox.shrink();
                  }
                  if (state.torchState == TorchState.unavailable) {
                    return const SizedBox.shrink();
                  }
                  final isOn = state.torchState == TorchState.on;
                  return IconButton(
                    icon: Icon(
                      isOn ? Symbols.flashlight_on : Symbols.flashlight_off,
                      color: isOn ? Colors.amber : c.onSurfaceVariant,
                    ),
                    tooltip: 'Flashlight',
                    onPressed: () => _controller.toggleTorch(),
                  );
                },
              ),

              // Close button
              IconButton(
                icon: Icon(Symbols.close, color: c.onSurfaceVariant),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Camera Viewport with Viewfinder
          SizedBox(
            height: scannerHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                    errorBuilder: (context, error) {
                      return Container(
                        color: c.surfaceContainerHighest,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Symbols.no_photography,
                                size: 48,
                                color: c.error,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l.shareData_scanner_permission_denied,
                                style: t.bodyMedium?.copyWith(
                                  color: c.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Viewfinder cutout and reticle overlay
                  const _ScannerOverlay(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Instruction Text
          Text(
            l.shareData_scanner_instruction,
            style: t.bodySmall?.copyWith(
              color: c.onSurfaceVariant,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = (constraints.maxWidth * 0.7).clamp(180.0, 240.0);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Darkened vignette background outside cutout
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.45),
                BlendMode.srcOut,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reticle frame
            Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.8),
                  width: 2.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

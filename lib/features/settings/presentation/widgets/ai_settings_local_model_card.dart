import 'dart:async';

import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Card widget inside AI Settings managing local Gemma AI model status,
/// progress streaming, download initiation, cancellation, and deletion.
class AiSettingsLocalModelCard extends StatefulWidget {
  final ModelDownloadService downloadService;
  final VoidCallback? onModelStatusChanged;

  const AiSettingsLocalModelCard({
    super.key,
    required this.downloadService,
    this.onModelStatusChanged,
  });

  @override
  State<AiSettingsLocalModelCard> createState() =>
      _AiSettingsLocalModelCardState();
}

class _AiSettingsLocalModelCardState extends State<AiSettingsLocalModelCard> {
  StreamSubscription<ModelDownloadProgress>? _subscription;
  bool _isDownloaded = false;
  bool _isLoading = true;
  ModelDownloadProgress _progress = const ModelDownloadProgress.idle();

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _subscription = widget.downloadService.progressStream.listen(
      _onProgressUpdated,
    );
  }

  Future<void> _checkInitialStatus() async {
    final downloaded = await widget.downloadService.isModelDownloaded();
    final current = widget.downloadService.currentProgress;
    if (mounted) {
      setState(() {
        _isDownloaded = downloaded;
        _progress = current;
        _isLoading = false;
      });
    }
  }

  void _onProgressUpdated(ModelDownloadProgress progress) {
    if (!mounted) return;
    setState(() {
      _progress = progress;
      if (progress.status == ModelDownloadStatus.completed) {
        _isDownloaded = true;
        widget.onModelStatusChanged?.call();
      } else if (progress.status == ModelDownloadStatus.idle &&
          !_isDownloaded) {
        widget.onModelStatusChanged?.call();
      }
    });
  }

  Future<void> _startDownload() async {
    widget.downloadService.startDownload();
  }

  void _cancelDownload() {
    widget.downloadService.cancelDownload();
  }

  Future<void> _confirmDelete() async {
    final WidgetVars(:l) = WidgetVars.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l.settings_delete_local_model_confirm_title),
          content: Text(l.settings_delete_local_model_confirm_desc),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.settings_cancel_download),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.settings_delete_local_model),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && mounted) {
      await widget.downloadService.deleteDownloadedModel();
      setState(() {
        _isDownloaded = false;
      });
      widget.onModelStatusChanged?.call();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    if (_isLoading) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final isDownloading = _progress.status == ModelDownloadStatus.downloading;
    final isFailed = _progress.status == ModelDownloadStatus.failed;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDownloading
              ? const Color(0xFF5B93AE)
              : c.outlineVariant.withAlpha(100),
          width: isDownloading ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLeadingIcon(c),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitleText(l),
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getSubtitleText(l),
                      style: t.bodySmall?.copyWith(
                        color: c.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isDownloaded && !isDownloading)
                IconButton(
                  tooltip: l.settings_delete_local_model,
                  icon: Icon(Symbols.delete, color: c.error),
                  onPressed: _confirmDelete,
                ),
            ],
          ),

          if (isDownloading) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress.totalBytes > 0
                    ? _progress.downloadedBytes / _progress.totalBytes
                    : null,
                minHeight: 8,
                backgroundColor: c.outlineVariant.withAlpha(80),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF5B93AE),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_progress.percentage}% (${_progress.formattedProgress})',
                  style: t.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: c.onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: _cancelDownload,
                  icon: const Icon(Symbols.close, size: 16),
                  label: Text(l.settings_cancel_download),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: c.error,
                  ),
                ),
              ],
            ),
          ],

          if (isFailed) ...[
            const SizedBox(height: 12),
            Text(
              _progress.errorMessage ?? l.ai_download_error_title,
              style: t.bodySmall?.copyWith(color: c.error),
            ),
            const SizedBox(height: 10),
            EmbossedButton(l.ai_download_retry, onPressed: _startDownload),
          ],

          if (!_isDownloaded && !isDownloading && !isFailed) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: EmbossedButton(
                l.settings_download_local_model,
                onPressed: _startDownload,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(ColorScheme c) {
    if (_progress.status == ModelDownloadStatus.downloading) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 3),
      );
    }

    if (_isDownloaded) {
      return const Icon(
        Symbols.check_circle,
        color: Color(0xFF2E7D32),
        size: 28,
      );
    }

    if (_progress.status == ModelDownloadStatus.failed) {
      return Icon(Symbols.error, color: c.error, size: 28);
    }

    return const Icon(
      Symbols.download_for_offline,
      color: Color(0xFF5B93AE),
      size: 28,
    );
  }

  String _getTitleText(AppLocalizations l) {
    if (_progress.status == ModelDownloadStatus.downloading) {
      return l.settings_local_model_downloading;
    }
    if (_isDownloaded) {
      return l.settings_local_model_downloaded('2.59GB');
    }
    if (_progress.status == ModelDownloadStatus.failed) {
      return l.ai_download_error_title;
    }
    return l.settings_local_model_not_downloaded;
  }

  String _getSubtitleText(AppLocalizations l) {
    if (_progress.status == ModelDownloadStatus.downloading) {
      return 'Gemma 4-E4B LiteRT-LM';
    }
    if (_isDownloaded) {
      return 'Gemma 4-E4B LiteRT-LM (Offline Ready)';
    }
    return 'Gemma 4-E4B (2.59 GB)';
  }
}

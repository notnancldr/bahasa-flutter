import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/login/domain/entities/ai_model_preference.dart';
import 'package:bahasa/features/login/domain/services/model_download_service.dart';
import 'package:bahasa/features/settings/domain/repositories/settings_repository.dart';
import 'package:bahasa/features/settings/presentation/widgets/ai_settings_local_model_card.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings subpage for configuring AI processing mode and local model downloads.
class AiSettingsPage extends StatefulWidget {
  final SettingsRepository? settingsRepository;
  final ModelDownloadService? downloadService;

  const AiSettingsPage({
    super.key,
    this.settingsRepository,
    this.downloadService,
  });

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage> {
  late final SettingsRepository _repository;
  late final ModelDownloadService _downloadService;

  AiModelType _currentMode = AiModelType.online;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository =
        widget.settingsRepository ??
        SettingsDependencies.createSettingsRepository();
    _downloadService = widget.downloadService ?? ModelDownloadService();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final mode = await _repository.getAiModelPreference();

    if (mounted) {
      setState(() {
        _currentMode = mode;
        _isLoading = false;
      });
    }
  }

  Future<void> _changeAiMode(AiModelType mode) async {
    setState(() => _currentMode = mode);
    await _repository.setAiModelPreference(mode);
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:l, :c, :t) = WidgetVars.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(title: l.settings_ai_title),
              const SizedBox(height: 24),

              // Mode Selection Section
              Text(
                l.ai_mode_choose_title,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              _buildModeOption(
                title: l.ai_mode_online_header,
                description: 'Gemini 1.5 Flash (${l.ai_feature_daily_limit})',
                mode: AiModelType.online,
                icon: Symbols.cloud,
              ),
              const SizedBox(height: 12),
              _buildModeOption(
                title: l.ai_mode_local_header,
                description:
                    'Gemma 4-E4B LiteRT-LM (${l.ai_feature_offline_use})',
                mode: AiModelType.local,
                icon: Symbols.memory,
              ),

              const SizedBox(height: 28),

              // Local Model Status & Download Section
              Text(
                l.settings_local_model_status,
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              AiSettingsLocalModelCard(
                downloadService: _downloadService,
                onModelStatusChanged: () {
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required String title,
    required String description,
    required AiModelType mode,
    required IconData icon,
  }) {
    final WidgetVars(:c, :t) = WidgetVars.of(context);
    final isSelected = _currentMode == mode;

    return InkWell(
      onTap: () => _changeAiMode(mode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF5F8) : c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B93AE)
                : c.outlineVariant.withAlpha(100),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF264653) : c.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? const Color(0xFF264653) : c.onSurface,
                    ),
                  ),
                  Text(
                    description,
                    style: t.bodySmall?.copyWith(
                      color: c.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Symbols.check_circle,
                color: Color(0xFF2E7D32),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/theme/theme_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ThemeSettingsPage extends StatelessWidget {
  final ThemeBloc? bloc;

  const ThemeSettingsPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ThemeBloc>();
      return const ThemeSettingsView();
    } catch (_) {
      return BlocProvider(
        create: (_) =>
            (bloc ?? SettingsDependencies.createThemeBloc())
              ..add(const LoadThemeEvent()),
        child: const ThemeSettingsView(),
      );
    }
  }
}

class ThemeSettingsView extends StatelessWidget {
  const ThemeSettingsView({super.key});

  void _onSelectTheme(BuildContext context, ThemeMode mode) {
    context.read<ThemeBloc>().add(ChangeThemeEvent(mode));
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {
        if (state.isApplied && context.canPop()) {
          context.pop();
        }
      },
      builder: (context, state) {
        final currentMode = state.themeMode;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(title: l.settings_title),
                  const SizedBox(height: 24),

                  Text(
                    l.theme_title,
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      color: c.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.theme_subtitle,
                    style: t.bodyMedium?.copyWith(
                      color: c.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  RadioGroup<ThemeMode>(
                    groupValue: currentMode,
                    onChanged: (mode) {
                      if (mode != null) _onSelectTheme(context, mode);
                    },
                    child: Column(
                      children: [
                        _ThemeOptionCard(
                          mode: ThemeMode.light,
                          title: l.theme_light,
                          isSelected: currentMode == ThemeMode.light,
                          isCardDark: false,
                          onTap: () => _onSelectTheme(context, ThemeMode.light),
                        ),
                        const SizedBox(height: 12),
                        _ThemeOptionCard(
                          mode: ThemeMode.dark,
                          title: l.theme_dark,
                          isSelected: currentMode == ThemeMode.dark,
                          isCardDark: true,
                          onTap: () => _onSelectTheme(context, ThemeMode.dark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final bool isSelected;
  final bool isCardDark;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.mode,
    required this.title,
    required this.isSelected,
    required this.isCardDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :t) = WidgetVars.of(context);
    final isSystemDark = Theme.of(context).brightness == Brightness.dark;

    final selectedBg = isSystemDark
        ? const Color(0xFF1E2D38)
        : const Color(0xFFF3F9FC);
    final unselectedBg = isSystemDark
        ? const Color(0xFF1E2630)
        : const Color(0xFFF3F3F1);

    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: cardShape.borderRadius.resolve(.ltr),
      child: Card(
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? selectedBg : unselectedBg,
            borderRadius:
                (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius,
            border: isSelected
                ? Border.all(color: const Color(0xFFA8D5E2), width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Mini phone mockup thumbnail
              Container(
                width: 52,
                height: 72,
                decoration: BoxDecoration(
                  color: isCardDark ? const Color(0xFF13171F) : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isCardDark
                        ? const Color(0xFF2C3847)
                        : const Color(0xFFE2E6E8),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCardDark
                            ? const Color(0xFF455566)
                            : const Color(0xFFA8D5E2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isCardDark
                            ? const Color(0xFF1E2630)
                            : const Color(0xFFF3F3F1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA8D5E2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 18,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isCardDark
                                ? const Color(0xFF2C3847)
                                : const Color(0xFFE2E6E8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: c.onSurface,
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFFA8D5E2)
                      : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: c.onSurfaceVariant.withAlpha(120),
                          width: 2,
                        ),
                ),
                child: isSelected
                    ? const Icon(
                        Symbols.check,
                        size: 16,
                        color: Color(0xFF1D4A5C),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

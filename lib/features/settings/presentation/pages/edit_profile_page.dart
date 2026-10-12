import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_icon.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button_colors.dart';
import 'package:bahasa/core/widgets/page_header.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_bloc.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_event.dart';
import 'package:bahasa/features/settings/presentation/bloc/account/account_state.dart';
import 'package:bahasa/features/settings/settings_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class EditProfilePage extends StatelessWidget {
  final AccountBloc? bloc;

  const EditProfilePage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: const EditProfileView());
    }

    try {
      context.read<AccountBloc>();
      return const EditProfileView();
    } catch (_) {
      return BlocProvider(
        create: (_) =>
            SettingsDependencies.createAccountBloc()
              ..add(const LoadAccountEvent()),
        child: const EditProfileView(),
      );
    }
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isValidUsername = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<AccountBloc>();
    final state = bloc.state;
    if (state is AccountLoaded) {
      _usernameController.text = state.profile.username;
      _isValidUsername = state.profile.username.trim().isNotEmpty;
    }
    _usernameController.addListener(_onUsernameChanged);
  }

  void _onUsernameChanged() {
    final valid = _usernameController.text.trim().isNotEmpty;
    if (valid != _isValidUsername) {
      setState(() {
        _isValidUsername = valid;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _onPickPhoto(BuildContext context) {
    context.read<AccountBloc>().add(const PickAndChangePhotoEvent());
  }

  void _onSave(BuildContext context) {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      context.read<AccountBloc>().add(ChangeUsernameEvent(newUsername));
    }
  }

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :t, :l, :s) = WidgetVars.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;

    return BlocConsumer<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountUsernameUpdated) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Username updated.')));
          if (context.canPop()) {
            context.pop();
          }
        } else if (state is AccountPhotoUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile photo updated.')),
          );
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AccountLoaded) {
          if (_usernameController.text.isEmpty) {
            _usernameController.text = state.profile.username;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF13171F)
              : const Color(0xFFF9FAFA),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(title: l.settings_title),
                        const SizedBox(height: 24),

                        Text(
                          l.editProfile_title,
                          style: t.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.editProfile_subtitle,
                          style: t.bodyMedium?.copyWith(
                            color: c.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Avatar Picker
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _onPickPhoto(context),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF1E2B33)
                                            : const Color(0xFFF3F9FC),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFA8D5E2),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Symbols.person,
                                        size: 48,
                                        color: Color(0xFF4C8A9E),
                                      ),
                                    ),
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFA8D5E2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Symbols.photo_camera,
                                        size: 16,
                                        color: Color(0xFF2C6378),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _onPickPhoto(context),
                                child: Text(
                                  l.editProfile_changePhoto,
                                  style: const TextStyle(
                                    color: Color(0xFF3E6E85),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Username Label
                        Text(
                          l.editProfile_usernameLabel,
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // TextField
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF1E2630)
                                : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: c.outline,
                                width: 1.2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: c.outline,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: c.primary,
                                width: 1.5,
                              ),
                            ),
                            suffixIcon: _isValidUsername
                                ? const Icon(
                                    Symbols.check_circle,
                                    color: Color(0xFF4A8A5A),
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.editProfile_usernameHint,
                          style: t.bodySmall?.copyWith(
                            color: c.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Info tip card
                        Card(
                          color: c.primaryContainer.withAlpha(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: cardShape.borderRadius,
                            side: BorderSide(color: c.primary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleIcon(
                                  Symbols.lightbulb,
                                  color: s.primaryDark,
                                  backgroundColor: Color(0xFFD6EFF8),
                                  size: 18,
                                  padding: EdgeInsets.all(6),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l.editProfile_tipTitle,
                                        style: t.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: c.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l.editProfile_tipBody,
                                        style: t.bodySmall?.copyWith(
                                          color: c.onSurfaceVariant,
                                          fontSize: 12,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Pinned Bottom Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: EmbossedButton(
                      l.editProfile_saveButton,
                      type: EmbossedButtonType.filled,
                      color: const EmbossedButtonColor(
                        background: Color(0xFFA8D5E2),
                        foreground: Color(0xFF1D4A5C),
                        shadow: Color(0xFF7CB8C9),
                      ),
                      onPressed: _isValidUsername
                          ? () => _onSave(context)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

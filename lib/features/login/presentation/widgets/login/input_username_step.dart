import 'package:bahasa/features/login/presentation/bloc/login/login_bloc.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_event.dart';
import 'package:bahasa/features/login/presentation/bloc/login/login_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class InputUsernameStep extends StatelessWidget {
  final InputState state;

  const InputUsernameStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final c = theme.colorScheme;
    final t = theme.textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoginStepHeader(
            l.newProfile_step_username_title,
            description: l.newProfile_step_username_description,
          ),
      
          SizedBox(height: 32),
      
          Text(
            l.newProfile_step_username_fieldName,
            style: t.titleMedium,
          ),
      
          SizedBox(height: 8),
      
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: c.outline,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
              color: c.surface,
            ),
            padding: EdgeInsets.only(left: 14),
            child: Row(
              children: [
                Icon(
                  Symbols.alternate_email,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return TextFormField(
                        initialValue: state is InputState ? state.username : "",
                        onChanged: (value) {
                          context.read<LoginBloc>().add(InputUsername(username: value));
                        },
                        decoration: InputDecoration(
                          hint: Text(l.newProfile_step_username_fieldPlaceholder),
                          contentPadding: EdgeInsets.all(0),
                          fillColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
      
          SizedBox(height: 4),
      
          Text(
            l.newProfile_step_username_fieldHint,
            style: t.labelSmall,
          ),
        ],
      ),
    );
  }
}
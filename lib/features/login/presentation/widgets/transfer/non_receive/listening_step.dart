import 'package:bahasa/core/theme/theme_extensions.dart';
import 'package:bahasa/core/widgets/rounded_box.dart';
import 'package:bahasa/core/widgets/rounded_container.dart';
import 'package:bahasa/core/widgets/waiting_dots.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login_step_header.dart';
import 'package:bahasa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ListeningStep extends StatelessWidget {
  final ListeningState state;

  const ListeningStep({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final l = AppLocalizations.of(context)!;
    final c = theme.colorScheme;
    final s = theme.extension<AppSemanticColors>()!;
    final t = theme.textTheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          LoginStepHeader(
            l.transfer_listening_title,
            description: l.transfer_listening_description,
          ),
      
          SizedBox(height: 16),
      
          RoundedBox(child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                l.transfer_listening_address,
                style: t.bodyMedium,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    state.ipHost,
                    style: t.titleMedium,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final data = ClipboardData(text: _hostUrl(state.ipHost));
                      Clipboard.setData(data);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(l.copied),
                        duration: Durations.extralong4,
                      ));
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateColor.fromMap({
                        WidgetState.any: s.primaryDark,
                      }),
                    ),
                    child: Row(
                      children: [
                        Icon(Symbols.content_copy),
                        SizedBox(width: 8),
                        Text(l.copy),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),

          SizedBox(height: 16),

          RoundedBox(child: Row(
            mainAxisAlignment: .center,
            children: [
              Column(
                children: [
                  RoundedContainer(
                    textContent: true,
                    child: Row(
                      children: [
                        Icon(
                          Symbols.qr_code_scanner,
                          size: 16,
                          color: s.primaryDark,
                        ),
                        SizedBox(width: 4),
                        Text(
                          l.transfer_listening_aboveQr,
                          style: t.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  RoundedContainer(
                    useBorder: true,
                    child: SizedBox(
                      height: 152,
                      width: 152,
                      child: PrettyQrView.data(
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(),
                          quietZone: .pixels(8)
                        ),
                        data: _hostUrl(state.ipHost),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  WaitingDots(color: c.primary),
                  SizedBox(height: 16),

                  Text(
                    l.transfer_listening_belowQr,
                    style: t.bodyMedium,
                  ),
                ],
              ),
            ],
          )),

          SizedBox(height: 8),

          RoundedContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Icon(
                    Symbols.wifi,
                    size: 16,
                    color: s.primaryDark,
                    weight: 800,
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Text(
                    l.transfer_listening_note,
                    style: t.labelMedium,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hostUrl(String ipHost) =>
      "http://$ipHost:7000";
}
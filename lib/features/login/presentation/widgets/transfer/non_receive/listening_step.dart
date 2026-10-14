import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/waiting_dots.dart';
import 'package:bahasa/features/login/presentation/bloc/transfer/transfer_state.dart';
import 'package:bahasa/features/login/presentation/widgets/login_step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ListeningStep extends StatelessWidget {
  final ListeningState state;

  const ListeningStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:theme, :c, :t, :s, :l) = WidgetVars.of(context);

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

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(l.transfer_listening_address, style: t.bodyMedium),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(state.ipHost, style: t.titleMedium),
                      OutlinedButton(
                        onPressed: () {
                          final data = ClipboardData(
                            text: _hostUrl(state.ipHost),
                          );
                          Clipboard.setData(data);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.copied),
                              duration: Durations.extralong4,
                            ),
                          );
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
              ),
            ),
          ),

          SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  Column(
                    children: [
                      Chip(
                        avatar: Icon(
                          Symbols.qr_code_scanner,
                          size: 16,
                          color: s.primaryDark,
                        ),
                        label: Text(
                          l.transfer_listening_aboveQr,
                          style: t.bodySmall,
                        ),
                        backgroundColor: c.surfaceContainerLow,
                        side: BorderSide.none,
                      ),

                      SizedBox(height: 16),

                      Card.outlined(
                        color: Colors.white,
                        child: SizedBox(
                          height: 152,
                          width: 152,
                          child: PrettyQrView.data(
                            decoration: const PrettyQrDecoration(
                              shape: PrettyQrSmoothSymbol(),
                              quietZone: .pixels(12),
                            ),
                            data: _hostUrl(state.ipHost),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      WaitingDots(color: c.primary),
                      SizedBox(height: 16),

                      Text(l.transfer_listening_belowQr, style: t.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                  Expanded(
                    child: Text(
                      l.transfer_listening_note,
                      style: t.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hostUrl(String ipHost) => "http://$ipHost:7000";
}

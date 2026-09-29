import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/login/presentation/widgets/security_footnote.dart';
import 'package:bahasa/features/login/presentation/widgets/welcome/option_card.dart';
import 'package:bahasa/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeView();
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Text(
                          l.welcome_startUsing,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          l.welcome_description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      OptionCard(
                        bgColor: Colors.orange.shade700.withAlpha(40),
                        iconColor: Color(0xFF885131),
                        icon: Symbols.person_add_rounded,
                        route: AppRoutes.loginNew,
                        title: l.welcome_newProfile_title,
                        description: l.welcome_newProfile_description,
                        nextText: l.welcome_nextButton,
                      ),
                      SizedBox(height: 32),
                      OptionCard(
                        bgColor: Colors.green.shade700.withAlpha(40),
                        iconColor: Colors.green.shade700,
                        icon: Symbols.download,
                        route: AppRoutes.loginImport,
                        title: l.welcome_sync_title,
                        description: l.welcome_sync_description,
                        nextText: l.welcome_nextButton,
                      ),
                    ],
                  ),
                ],
              ),
              SecurityFootnote(),
            ],
          ),
        ),
      ),
    );
  }
}
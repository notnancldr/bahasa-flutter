import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/features/login/presentation/widgets/security_footnote.dart';
import 'package:bahasa/features/login/presentation/widgets/welcome/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:your_app/core/router/app_routes.dart';
// import 'package:your_app/features/auth/repository/auth_repository.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 54),
                      child: Column(
                        children: [
                          Text(
                            "Mulai Gunakan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Pilih cara Anda memulai pembelajaran hari ini.",
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
                          bgColor: Colors.green.shade500.withAlpha(40),
                          iconColor: Colors.green.shade500,
                          icon: Icons.person_add,
                          route: AppRoutes.loginNew,
                          title: "Buat Profil Baru",
                          description: "Mulai dari awal dengan profil baru.",
                          nextText: "Mulai Sekarang",
                        ),
                        SizedBox(height: 32),
                        OptionCard(
                          bgColor: Colors.green.shade500.withAlpha(40),
                          iconColor: Colors.green.shade500,
                          icon: Icons.person_add,
                          route: AppRoutes.loginNew,
                          title: "Buat Profil Baru",
                          description: "Mulai dari awal dengan profil baru.",
                          nextText: "Mulai Sekarang",
                        ),
                      ],
                    ),

                    // EmbossedButton(),
                  ],
                ),
                SecurityFootnote(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
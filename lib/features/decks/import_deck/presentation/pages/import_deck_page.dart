import 'package:bahasa/core/router/app_routes.dart';
import 'package:bahasa/core/utils/widget_var.dart';
import 'package:bahasa/core/widgets/circle_back_button.dart';
import 'package:bahasa/core/widgets/embossed_button/embossed_button.dart';
import 'package:bahasa/features/decks/decks_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../bloc/import_deck_bloc.dart';
import '../bloc/import_deck_event.dart';
import '../bloc/import_deck_state.dart';
import '../widgets/import_dropzone_empty.dart';
import '../widgets/import_error_view.dart';
import '../widgets/import_file_card_selected.dart';
import '../widgets/import_progress_view.dart';
import '../widgets/import_success_review_view.dart';

/// Full-screen view for the .euy file import workflow.
class ImportDeckPage extends StatelessWidget {
  final ImportDeckBloc? bloc;

  const ImportDeckPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: const _ImportDeckView());
    }

    return BlocProvider(
      create: (_) => DecksDependencies.createImportDeckBloc(),
      child: const _ImportDeckView(),
    );
  }
}

class _ImportDeckView extends StatelessWidget {
  const _ImportDeckView();

  @override
  Widget build(BuildContext context) {
    final WidgetVars(:c, :t, :l) = WidgetVars.of(context);

    return BlocConsumer<ImportDeckBloc, ImportDeckState>(
      listener: (context, state) {
        if (state is ImportDoneState) {
          context.go(AppRoutes.deck);
        }
      },
      builder: (context, state) {
        final bloc = context.read<ImportDeckBloc>();
        final isPicker = state is ImportPickerState;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bar
                  Row(
                    children: [
                      if (isPicker) const CircleBackButton(),
                      Expanded(
                        child: Text(
                          l.deck_import_appbar_title,
                          style: t.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.onSurface,
                          ),
                          textAlign: isPicker
                              ? TextAlign.center
                              : TextAlign.center,
                        ),
                      ),
                      if (isPicker) const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Body
                  Expanded(
                    child: switch (state) {
                      ImportPickerState(
                        :final hasFile,
                        :final fileName,
                        :final fileSizeFormatted,
                      ) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              l.deck_import_title,
                              style: t.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: c.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l.deck_import_subtitle,
                              style: t.bodySmall?.copyWith(
                                color: c.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 36),
                            if (!hasFile)
                              ImportDropzoneEmpty(
                                onPickFile: () =>
                                    bloc.add(const PickFileRequested()),
                              )
                            else
                              ImportFileCardSelected(
                                fileName: fileName ?? '',
                                fileSizeFormatted: fileSizeFormatted ?? '',
                                onChangeFile: () =>
                                    bloc.add(const PickFileRequested()),
                              ),
                            const Spacer(),
                            EmbossedButton(
                              l.deck_continue,
                              onPressed: hasFile
                                  ? () => bloc.add(
                                      const StartImportProcessRequested(),
                                    )
                                  : null,
                              trailingIcon: Symbols.arrow_forward,
                            ),
                          ],
                        ),

                      ImportVerifyingState(:final fileName, :final progress) =>
                        ImportProgressView(
                          title: l.deck_import_verifying_title,
                          subtitle: l.deck_import_verifying_subtitle,
                          fileName: fileName,
                          progress: progress,
                          onRunInBackground: () => context.go(AppRoutes.deck),
                        ),

                      ImportImportingState(:final fileName, :final progress) =>
                        ImportProgressView(
                          title: l.deck_import_importing_title,
                          subtitle: l.deck_import_verifying_subtitle,
                          fileName: fileName,
                          progress: progress,
                          onRunInBackground: () => context.go(AppRoutes.deck),
                        ),

                      ImportErrorState(:final errorMessage) => ImportErrorView(
                        errorMessage: errorMessage,
                        onPickAnother: () =>
                            bloc.add(const PickFileRequested()),
                      ),

                      ImportSuccessReviewState(
                        :final deck,
                        :final fileSizeFormatted,
                      ) =>
                        ImportSuccessReviewView(
                          deck: deck,
                          fileSizeFormatted: fileSizeFormatted,
                          onContinue: () =>
                              bloc.add(ConfirmImportCompleted(deck)),
                        ),

                      ImportDoneState() => const SizedBox.shrink(),
                    },
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

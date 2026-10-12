import 'package:bahasa/core/widgets/info_chip.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class FileChip extends StatelessWidget {
  final String fileName;

  const FileChip({super.key, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return InfoChip(leading: Symbols.folder, text: fileName);
  }
}

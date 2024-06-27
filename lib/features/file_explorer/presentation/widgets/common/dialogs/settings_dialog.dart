import 'package:flutter/material.dart';

Future<void> showSettingsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('Настройки'),
      content: const Text('Меню настроек'),
    ),
  );
}

import 'package:flutter/material.dart';

Future<void> showSettingsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('Настройки'),
      content: const Text('Меню настроек'),
      actions: <Widget>[
        TextButton(
          child: const Text('ОК'),
          onPressed: () {
            // TODO: применить настройки и выйти из настроек
            Navigator.of(dialogContext).pop();
          },
        ),
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            // TODO: отменить настройки и выйти из настроек
            Navigator.of(dialogContext).pop();
          },
        ),
        TextButton(
          child: const Text('Применить'),
          onPressed: () {
            // TODO: применить настройки
          },
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

void showErrorPermissionDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock, color: colorScheme.error),
            SizedBox(width: 10),
            Text(
              'Ошибка разрешения',
              style: TextStyle(color: colorScheme.error),
            ),
          ],
        ),
        content: Text(
          'Вы не дали разрешения приложению!',
          style: TextStyle(fontSize: 16, color: colorScheme.error),
        ),
        backgroundColor: colorScheme.surface,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Закрыть',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      );
    },
  );
}

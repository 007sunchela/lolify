import 'package:flutter/material.dart';

void showErrorDownloadDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error, color: colorScheme.error),
            SizedBox(width: 10),
            Text(
              'Ошибка скачивания',
              style: TextStyle(color: colorScheme.error),
            ),
          ],
        ),
        content: Text(
          'Мем неуспешно скачан!',
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

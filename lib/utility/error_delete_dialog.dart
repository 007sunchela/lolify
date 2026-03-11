import 'package:flutter/material.dart';

void showErrorDeleteDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error, color: colorScheme.error),
            SizedBox(width: 10),
            Text('Ошибка удаления', style: TextStyle(color: colorScheme.error)),
          ],
        ),
        content: Text(
          'Мем неуспешно удален!',
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

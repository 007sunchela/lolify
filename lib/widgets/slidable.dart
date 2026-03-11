import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lolify/models/meme_model.dart';
import 'package:lolify/widgets/card_meme.dart';

class SlidableWidget extends StatelessWidget {
  final Meme meme;
  final Future<void>? Function()? onAdd;
  final Future<void>? Function()? onDelete;
  final Future<void> Function() onSave;
  final Function() onShare;
  final int flag;

  const SlidableWidget({
    super.key,
    required this.meme,
    this.onAdd,
    this.onDelete,
    required this.onSave,
    required this.onShare,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(meme.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (_) {
              if (flag == 0) {
                onAdd!();
              } else {
                onDelete!();
              }
            },
            backgroundColor: flag == 0 ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
            icon: flag == 0 ? Icons.add : Icons.delete,
            label: flag == 0 ? 'Добавить' : 'Удалить',
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.all(8),
          ),
          SlidableAction(
            onPressed: (_) => onSave(),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            icon: Icons.download,
            label: 'Скачать',
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.all(8),
          ),
          SlidableAction(
            onPressed: (_) => onShare(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Поделиться',
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
      child: CardMeme(imageUrl: meme.imageUrl, desc: meme.desc),
    );
  }
}

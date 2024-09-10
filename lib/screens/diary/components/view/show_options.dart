import 'package:flutter/material.dart';
import 'package:luna/constants/colors.dart';
import 'package:luna/models/diary_entry.dart';
import 'package:luna/screens/diary/components/insert_diary.dart';

Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que quieres eliminar este diario?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Eliminar'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ) ?? false;
}

class DiaryCardOptions extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const DiaryCardOptions({
    Key? key,
    required this.entry,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.edit, size: 18),
            title: const Text('Editar', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDiaryScreen(
                    entry: entry,
                    onEntryUpdated: onUpdate,
                  ),
                ),
              );
            },
          ),
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? SeparatorColors.darkSeparator
                : SeparatorColors.lightSeparator,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red, size: 18),
            title: const Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ActionPopupMenu extends StatelessWidget {
  final Map<String, Function()> actions;

  const ActionPopupMenu({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (key) {
        if (actions.containsKey(key)) {
          actions[key]!();
        }
      },
      itemBuilder: (context) => actions.entries.map((entry) {
        // Tentukan icon dan warna berdasarkan key
        IconData icon;
        Color color;

        if (entry.key == 'detail') {
          icon = Icons.info_outline;
          color = Colors.blue;
        } else if (entry.key == 'edit') {
          icon = Icons.edit_outlined;
          color = Colors.orange;
        } else if (entry.key == 'delete') {
          icon = Icons.delete_outline;
          color = Colors.red;
        } else {
          icon = Icons.arrow_right;
          color = Colors.grey;
        }

        return PopupMenuItem<String>(
          value: entry.key,
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                _getLabel(entry.key),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getLabel(String key) {
    switch (key) {
      case 'detail':
        return 'Detail Stok';
      case 'edit':
        return 'Edit Stok';
      case 'delete':
        return 'Hapus Stok';
      default:
        return key.substring(0, 1).toUpperCase() + key.substring(1);
    }
  }
}

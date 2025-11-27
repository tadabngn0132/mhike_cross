import 'package:flutter/material.dart';
import '../../models/hike.dart';
class HikeCard extends StatelessWidget {
  final Hike hike;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const HikeCard({
    super.key,
    required this.hike,
    required this.onEdit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            hike.name.isNotEmpty ? hike.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          hike.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By ${hike.location}'),
            const SizedBox(height: 4),
            if (hike.description.isNotEmpty)
              Text(
                hike.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit hike',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete hike',
            ),
          ],
        ),

        onTap: onEdit,
        isThreeLine: hike.description.isNotEmpty,
      ),
    );
  }
}
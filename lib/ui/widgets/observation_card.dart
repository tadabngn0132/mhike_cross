import 'package:flutter/material.dart';
import '../../models/observation.dart';
class ObservationCard extends StatelessWidget {
  final Observation observation;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const ObservationCard({
    super.key,
    required this.observation,
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
            observation.title.isNotEmpty ? observation.title[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          observation.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By ${observation.title}'),
            const SizedBox(height: 4),
            if (observation.comments.isNotEmpty)
              Text(
                observation.comments,
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
              tooltip: 'Edit observation',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete observation',
            ),
          ],
        ),

        onTap: onEdit,
        isThreeLine: observation.comments.isNotEmpty,
      ),
    );
  }
}
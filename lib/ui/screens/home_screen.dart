import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hike_provider.dart';
import '../../models/hike.dart';
import '../widgets/hike_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'add_edit_hike_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hike Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HikeProvider>().loadHikes(),
          ),
        ],
      ),
      body: Consumer<HikeProvider>(
        builder: (context, hikeProvider, child) {
          if (hikeProvider.isLoading && hikeProvider.hikes.isEmpty) {
            return const LoadingWidget(message: 'Loading hikes...');
          }
          if (hikeProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: hikeProvider.errorMessage!,
              onRetry: () => hikeProvider.loadHikes(),
            );
          }
          if (!hikeProvider.hasHikes) {
            return const EmptyState();
          }
          return RefreshIndicator(
            onRefresh: () => hikeProvider.loadHikes(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: hikeProvider.hikes.length,
              itemBuilder: (context, index) {
                final hike = hikeProvider.hikes[index];
                return HikeCard(
                  hike: hike,
                  onEdit: () => _navigateToEditScreen(context, hike),
                  onDelete: () => _showDeleteDialog(context, hike),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => const AddEditHikeScreen(),
      ),
    );
  }
  void _navigateToEditScreen(BuildContext context, Hike hike) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditHikeScreen(hike: hike),
      ),
    );
  }
  void _showDeleteDialog(BuildContext context, Hike hike) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hike'),
        content: Text('Are you sure you want to delete "${hike.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<HikeProvider>().deleteHike(hike.id!);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
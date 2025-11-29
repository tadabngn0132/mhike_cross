import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hike_viewmodel.dart';
import '../models/hike.dart';
import 'add_edit_hike_screen.dart';
/// Screen that displays a list of all hikes
class HikeListScreen extends StatelessWidget {
  const HikeListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hike Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<HikeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.hikes.isEmpty) {
            return _buildLoadingWidget();
          }
          if (viewModel.errorMessage != null) {
            return _buildErrorWidget(context, viewModel);
          }

          if (viewModel.hikes.isEmpty) {
            return _buildEmptyWidget(context);
          }
          return _buildHikeList(context, viewModel);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddHike(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildErrorWidget(BuildContext context, HikeViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.loadHikes(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Hikes Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first hike by tapping the + button',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  Widget _buildHikeList(BuildContext context, HikeViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: viewModel.hikes.length,
      itemBuilder: (context, index) {
        final hike = viewModel.hikes[index];
        return _buildHikeCard(context, viewModel, hike);
      },
    );
  }
  Widget _buildHikeCard(BuildContext context, HikeViewModel viewModel, Hike hike) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By ${hike.location}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (hike.description.isNotEmpty)

              Text(
                hike.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () => _navigateToEditHike(context, hike),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteConfirmation(context, viewModel, hike),
        ),
      ),
    );
  }
  void _navigateToAddHike(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditHikeScreen(),
      ),
    );
  }
  void _navigateToEditHike(BuildContext context, Hike hike) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditHikeScreen(hike: hike),
      ),
    );
  }
  void _showDeleteConfirmation(
      BuildContext context,
      HikeViewModel viewModel,
      Hike hike,
      ) {
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
              viewModel.deleteHike(hike.id!);
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
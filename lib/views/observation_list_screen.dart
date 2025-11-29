import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/observation_viewmodel.dart';
import '../models/observation.dart';
import 'add_edit_observation_screen.dart';
/// Screen that displays a list of all observations
class ObservationListScreen extends StatelessWidget {
  const ObservationListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation Library'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<ObservationViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.observations.isEmpty) {
            return _buildLoadingWidget();
          }
          if (viewModel.errorMessage != null) {
            return _buildErrorWidget(context, viewModel);
          }

          if (viewModel.observations.isEmpty) {
            return _buildEmptyWidget(context);
          }
          return _buildObservationList(context, viewModel);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddObservation(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildErrorWidget(BuildContext context, ObservationViewModel viewModel) {
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
            onPressed: () => viewModel.loadObservations(),
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
            'No Observations Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first observation by tapping the + button',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  Widget _buildObservationList(BuildContext context, ObservationViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: viewModel.observations.length,
      itemBuilder: (context, index) {
        final observation = viewModel.observations[index];
        return _buildObservationCard(context, viewModel, observation);
      },
    );
  }
  Widget _buildObservationCard(BuildContext context, ObservationViewModel viewModel, Observation observation) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By ${observation.comments}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (observation.comments.isNotEmpty)

              Text(
                observation.comments,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () => _navigateToEditObservation(context, observation),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteConfirmation(context, viewModel, observation),
        ),
      ),
    );
  }
  void _navigateToAddObservation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditObservationScreen(),
      ),
    );
  }
  void _navigateToEditObservation(BuildContext context, Observation observation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditObservationScreen(observation: observation),
      ),
    );
  }
  void _showDeleteConfirmation(
      BuildContext context,
      ObservationViewModel viewModel,
      Observation observation,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Observation'),
        content: Text('Are you sure you want to delete "${observation.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteObservation(observation.id!);
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
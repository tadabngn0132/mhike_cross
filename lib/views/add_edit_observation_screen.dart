import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/observation.dart';
import '../viewmodels/observation_viewmodel.dart';
/// Screen for adding new observations or editing existing observations
class AddEditObservationScreen extends StatefulWidget {
  final Observation? observation;
  const AddEditObservationScreen({Key? key, this.observation}) : super(key: key);
  @override
  State<AddEditObservationScreen> createState() => _AddEditObservationScreenState();
}
class _AddEditObservationScreenState extends State<AddEditObservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timestampController = TextEditingController();
  final _commentsController = TextEditingController();
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    if (widget.observation != null) {
      _titleController.text = widget.observation!.title;
      _timestampController.text = widget.observation!.timestamp.toString();
      _commentsController.text = widget.observation!.comments;
    }
  }
  @override
  void dispose() {
    _titleController.dispose();
    _timestampController.dispose();
    _commentsController.dispose();
    super.dispose();
  }
  Future<void> _saveObservation() async {
    if (!_formKey.currentState!.validate()) {
      return;

    }
    setState(() {
      _isSaving = true;
    });
    try {
      final viewModel = Provider.of<ObservationViewModel>(context, listen: false);
      final observation = Observation(
        id: widget.observation?.id,
        title: _titleController.text.trim(),
        timestamp: DateTime.parse(_timestampController.text.trim()),
        comments: _commentsController.text.trim(),
        hikeId: widget.observation?.hikeId ?? 0,
      );
      if (widget.observation == null) {
        await viewModel.addObservation(observation);
        _showSuccessMessage('Observation added successfully!');
      } else {
        await viewModel.updateObservation(observation);
        _showSuccessMessage('Observation updated successfully!');
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (error) {
      _showErrorMessage('Error: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,

        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.observation != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Observation' : 'Add New Observation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildAuthorField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSaveButton(isEditing),
              const SizedBox(height: 16),
              _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title *',
        hintText: 'Enter observation title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.book),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        if (value.trim().length < 2) {
          return 'Title must be at least 2 characters';
        }
        return null;
      },

      textInputAction: TextInputAction.next,
    );
  }
  Widget _buildAuthorField() {
    return TextFormField(
      controller: _timestampController,
      decoration: const InputDecoration(
        labelText: 'Author *',
        hintText: 'Enter timestamp name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an timestamp';
        }
        if (value.trim().length < 2) {
          return 'Author name must be at least 2 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _commentsController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter observation comments (optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.book),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _saveObservation(),
    );
  }
  Widget _buildSaveButton(bool isEditing) {
    return ElevatedButton.icon(
      onPressed: _isSaving ? null : _saveObservation,
      icon: _isSaving
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(isEditing ? Icons.save : Icons.add),
      label: Text(_isSaving ? 'Saving...' : (isEditing ? 'Update Observation' : 'Add Observation')),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),

      ),
    );
  }
  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: _isSaving ? null : () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }
}
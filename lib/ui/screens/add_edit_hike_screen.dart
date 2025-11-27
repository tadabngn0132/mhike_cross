import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hike_provider.dart';
import '../../models/hike.dart';
class AddEditHikeScreen extends StatefulWidget {
  final Hike? hike;
  const AddEditHikeScreen({super.key, this.hike});
  @override

  State<AddEditHikeScreen> createState() => _AddEditHikeScreenState();
}
class _AddEditHikeScreenState extends State<AddEditHikeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _parkingAvailableController;
  late TextEditingController _lengthController;
  late TextEditingController _difficultyController;
  late TextEditingController _descriptionController;
  bool _isSaving = false;
  bool get isEditing => widget.hike != null;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hike?.name ?? '');
    _locationController = TextEditingController(text: widget.hike?.location ?? '');
    _dateController = TextEditingController(text: widget.hike?.date ?? '');
    _parkingAvailableController = TextEditingController(text: widget.hike?.parkingAvailable ?? '');
    _lengthController = TextEditingController(text: widget.hike?.length ?? '');
    _difficultyController = TextEditingController(text: widget.hike?.difficulty ?? '');
    _descriptionController = TextEditingController(text: widget.hike?.description ?? '');
  }
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _parkingAvailableController.dispose();
    _lengthController.dispose();
    _difficultyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Hike' : 'Add Hike'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<HikeProvider>(
        builder: (context, hikeProvider, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildAuthorField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  const SizedBox(height: 16),
                  _buildCancelButton(),
                ],
              ),

            ),
          );
        },
      ),
    );
  }
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name *',
        hintText: 'Enter hike name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.book),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
  Widget _buildAuthorField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Author *',
        hintText: 'Enter location name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an location';
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
      controller: _descriptionController,
      decoration: const InputDecoration(

        labelText: 'Description',
        hintText: 'Enter hike description (optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _saveHike(),
    );
  }
  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _isSaving ? null : _saveHike,
      icon: _isSaving
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(isEditing ? Icons.save : Icons.add),
      label: Text(_isSaving ? 'Saving...' : (isEditing ? 'Update Hike' : 'Add Hike')),
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
  Future<void> _saveHike() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      final hike = Hike(
        id: widget.hike?.id,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        date: _dateController.text.trim(),
        parkingAvailable: _parkingAvailableController.text.trim(),
        length: _lengthController.text.trim(),
        difficulty: _difficultyController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      final hikeProvider = context.read<HikeProvider>();

      if (isEditing) {
        await hikeProvider.updateHike(hike);
        _showSuccessMessage('Hike updated successfully!');
      } else {
        await hikeProvider.addHike(hike);
        _showSuccessMessage('Hike added successfully!');
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
}
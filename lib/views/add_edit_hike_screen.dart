import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hike.dart';
import '../viewmodels/hike_viewmodel.dart';
/// Screen for adding new hikes or editing existing hikes
class AddEditHikeScreen extends StatefulWidget {
  final Hike? hike;
  const AddEditHikeScreen({Key? key, this.hike}) : super(key: key);
  @override
  State<AddEditHikeScreen> createState() => _AddEditHikeScreenState();
}
class _AddEditHikeScreenState extends State<AddEditHikeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _lengthController = TextEditingController();
  final _parkingAvailableController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    if (widget.hike != null) {
      _nameController.text = widget.hike!.name;
      _locationController.text = widget.hike!.location;
      _dateController.text = widget.hike!.date.toString();
      _lengthController.text = widget.hike!.length.toString();
      _parkingAvailableController.text = widget.hike!.parkingAvailable ? 'Yes' : 'No';
      _difficultyController.text = widget.hike!.difficulty;
      _descriptionController.text = widget.hike!.description;
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _lengthController.dispose();
    _parkingAvailableController.dispose();
    _difficultyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  Future<void> _saveHike() async {
    if (!_formKey.currentState!.validate()) {
      return;

    }
    setState(() {
      _isSaving = true;
    });
    try {
      final viewModel = Provider.of<HikeViewModel>(context, listen: false);
      final hike = Hike(
        id: widget.hike?.id,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        date: DateTime.parse(_dateController.text.trim()),
        length: double.parse(_lengthController.text.trim()),
        parkingAvailable: _parkingAvailableController.text.trim().toLowerCase() == 'yes',
        difficulty: _difficultyController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      if (widget.hike == null) {
        await viewModel.addHike(hike);
        _showSuccessMessage('Hike added successfully!');
      } else {
        await viewModel.updateHike(hike);
        _showSuccessMessage('Hike updated successfully!');
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
    final isEditing = widget.hike != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Hike' : 'Add New Hike'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNameField(),
              const SizedBox(height: 16),
              _buildLocationField(),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildLengthField(),
              const SizedBox(height: 16),
              _buildParkingAvailableField(),
              const SizedBox(height: 16),
              _buildDifficultyField(),
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
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name *',
        hintText: 'Enter hike name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.hiking),
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
  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Location *',
        hintText: 'Enter location',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an location';
        }
        if (value.trim().length < 2) {
          return 'Location must be at least 2 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
  Widget _buildDateField() {
    return InputDatePickerFormField(
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      fieldLabelText: 'Date *',
      initialDate: widget.hike?.date ?? DateTime.now(),
      onDateSaved: (date) {
        _dateController.text = date.toIso8601String();
      },
      onDateSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
  Widget _buildLengthField() {
    return TextFormField(
      controller: _lengthController,
      decoration: const InputDecoration(
        labelText: 'Length *',
        hintText: 'Enter length',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.route),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a date';
        }
        if (value.trim().length < 2) {
          return 'Length must be at least 2 characters';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
  Widget _buildParkingAvailableField() {
    return SwitchListTile(
      title: const Text('Parking Available'),
      value: _parkingAvailableController.text.trim().toLowerCase() == 'yes',
      onChanged: (value) {
        setState(() {
          _parkingAvailableController.text = value ? 'Yes' : 'No';
        });
      },
      secondary: const Icon(Icons.local_parking),
    );
  }
  Widget _buildDifficultyField() {
    return DropdownMenuFormField(
      controller: _difficultyController,
      width: double.infinity,
      initialSelection: _difficultyController.text.trim() ?? 'Easy',
      label: const Text('Difficulty *'),
      leadingIcon: const Icon(Icons.landscape),
      dropdownMenuEntries: [
        const DropdownMenuEntry(value: 'Easy', label: 'Easy'),
        const DropdownMenuEntry(value: 'Moderate', label: 'Moderate'),
        const DropdownMenuEntry(value: 'Hard', label: 'Hard'),
      ],
      onSelected: (String? value) {
        if (value != null) {
          _difficultyController.text = value;
        }
      },
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
  Widget _buildSaveButton(bool isEditing) {
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
}
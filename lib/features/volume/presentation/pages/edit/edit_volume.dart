import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/singlevolume/singlevolume_bloc.dart';
import 'package:journal_web/features/volume/presentation/bloc/volume/volume_bloc.dart';

class EditVolumePage extends StatefulWidget {
  const EditVolumePage({super.key});

  @override
  _EditVolumePageState createState() => _EditVolumePageState();
}

class _EditVolumePageState extends State<EditVolumePage> {
  final _formKey = GlobalKey<FormState>();
  late VolumeModel volumeModel;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _volumeNumberController;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    final String volumeId = Get.parameters['volumeId']!;
    context
        .read<SinglevolumeBloc>()
        .add(GetSingleVolumeEvent(volumeId: volumeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Volume', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: BlocBuilder<SinglevolumeBloc, SinglevolumeState>(
        builder: (context, state) {
          if (state is SingleVolumeLoaded) {
            volumeModel = state.volume;
            _initializeControllers();
            return _buildForm();
          } else if (state is SingleVolumeLoading) {
            return Center(
                child: CircularProgressIndicator(color: Colors.orange));
          } else {
            return Center(
                child: Text('Failed to load volume',
                    style: TextStyle(color: Colors.red)));
          }
        },
      ),
    );
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: volumeModel.title);
    _descriptionController =
        TextEditingController(text: volumeModel.description);
    _volumeNumberController =
        TextEditingController(text: volumeModel.volumeNumber);
    _isActive = volumeModel.isActive ?? false;
  }

  Widget _buildForm() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double maxWidth =
                  constraints.maxWidth > 600 ? 600 : constraints.maxWidth;
              return SizedBox(
                width: maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: 'Title',
                      icon: Icons.title,
                      color: Colors.blue,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a title' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      color: Colors.green,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _volumeNumberController,
                      label: 'Volume Number',
                      icon: Icons.book,
                      color: Colors.orange,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter a volume number'
                          : null,
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Is Active',
                          style: TextStyle(
                              color: Colors.purple[700], fontSize: 18)),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeColor: Colors.purple,
                      secondary: Icon(
                          _isActive ? Icons.toggle_on : Icons.toggle_off,
                          color: Colors.purple,
                          size: 30),
                    ),
                    SizedBox(height: 32),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: Icon(Icons.save, size: 24),
                        label: Text('Save Changes',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color),
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      volumeModel.title = _titleController.text;
      volumeModel.description = _descriptionController.text;
      volumeModel.volumeNumber = _volumeNumberController.text;
      volumeModel.isActive = _isActive;

      context.read<VolumeBloc>().add(UpdateVolumeEvent(volume: volumeModel));
      Get.back(result: true);
      context
          .read<SinglevolumeBloc>()
          .add(GetSingleVolumeEvent(volumeId: volumeModel.id!));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _volumeNumberController.dispose();
    super.dispose();
  }
}

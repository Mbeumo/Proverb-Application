import 'dart:io';
import 'package:flutter/foundation.dart'; // for kIsWeb

import 'package:flutter/material.dart';
import 'package:proverbapp/services/authservice.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proverbapp/services/storageservice.dart';

class EditProfileView extends StatefulWidget {
  final AuthService authService;
  final StorageService storage;
  const EditProfileView({super.key, required this.authService,required this.storage});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  String? _profileImageUrl;
  File? _pickedImage; // For mobile
  Uint8List? _pickedImageBytes; // For web


  @override
  void initState() {
    super.initState();
    final user = widget.authService.currentUser;
    _displayNameController = TextEditingController(text: user?.displayName);
    _profileImageUrl = user?.photoURL;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Update display name
        await widget.authService.updateDisplayName(_displayNameController.text);

        // Update profile picture (if changed)
        if (_profileImageUrl != null) {
          await widget.authService.updateProfilePicture(_profileImageUrl!);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Navigate back to AccountView
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final user = widget.authService.currentUser;
      if (user == null) return;

      final destinationPath = 'profilePictures/${user.uid}.jpg';

      if (kIsWeb) {
        // On web, use the raw bytes directly.
        Uint8List fileBytes = await pickedFile.readAsBytes();
        // Show a local preview using MemoryImage.
        setState(() {
          _pickedImageBytes = fileBytes;
        });
        String downloadUrl = await widget.storage.uploadImage(
          bytes: fileBytes,
          destinationPath: destinationPath,
        );
        setState(() {
          _profileImageUrl = downloadUrl;
          _pickedImageBytes = null; // Optionally clear the local preview after upload.
        });
      } else {
        // On mobile, create a File from the picked file path.
        File imageFile = File(pickedFile.path);
        setState(() {
          _pickedImage = imageFile;
        });
        String downloadUrl = await widget.storage.uploadImage(
          file: imageFile,
          destinationPath: destinationPath,
        );
        setState(() {
          _profileImageUrl = downloadUrl;
          _pickedImage = null;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (kIsWeb && _pickedImageBytes != null) {
      imageProvider = MemoryImage(_pickedImageBytes!);
    } else if (!kIsWeb && _pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (_profileImageUrl != null) {
      imageProvider = NetworkImage(_profileImageUrl!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:imageProvider,
                  child:imageProvider == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Display Name Field
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
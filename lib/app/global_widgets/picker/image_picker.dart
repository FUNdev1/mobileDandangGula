import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatelessWidget {
  final File? selectedImage;
  final Function(File?) onImageSelected;

  const CustomImagePicker({
    super.key,
    this.selectedImage,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF0D4927),
              shape: BoxShape.circle,
              image: selectedImage != null
                  ? DecorationImage(
                      image: FileImage(selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: selectedImage == null
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  )
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18),
                padding: EdgeInsets.zero,
                onPressed: () => _showImageSourceOptions(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImageSourceOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.of(context).pop();
              _getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              _getImage(ImageSource.gallery);
            },
          ),
          if (selectedImage != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                onImageSelected(null);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }
}
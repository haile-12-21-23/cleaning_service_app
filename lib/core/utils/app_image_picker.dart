import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick from camera
  static Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image == null) return null;

    return File(image.path);
  }

  /// Pick from gallery
  static Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) return null;

    return File(image.path);
  }

  /// Show option sheet
  static Future<File?> showImagePicker(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  final file = await pickFromCamera();

                  Navigator.pop(context, file);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  final file = await pickFromGallery();

                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

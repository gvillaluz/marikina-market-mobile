import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/widgets/evidence_gallery_screen.dart';

class AddPhotoEvidenceBtn extends StatefulWidget {
  final List<XFile> photos;
  final ValueChanged<XFile> onPhotoAdded;
  final ValueChanged<int> onPhotoRemoved;
  final bool isInvalid;

  const AddPhotoEvidenceBtn({
    required this.photos,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
    required this.isInvalid,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AddPhotoEvidenceBtnState();
}

class _AddPhotoEvidenceBtnState extends State<AddPhotoEvidenceBtn> {
  Future<void> _captureEvidence() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return;

    widget.onPhotoAdded(photo);
  }

  @override
  Widget build(BuildContext context) {
    bool isPhotosEmpty = widget.photos.isEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: _captureEvidence,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: isPhotosEmpty ? 150 : 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isInvalid
                    ? AppColors.primaryRed
                    : AppColors.lightGrey,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, size: isPhotosEmpty ? 30 : 20),
                const SizedBox(height: 10),
                Text(
                  'Tap to take a photo',
                  style: TextStyle(fontSize: isPhotosEmpty ? 15 : 12),
                ),
              ],
            ),
          ),
        ),

        if (!isPhotosEmpty) ...[
          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
            ),
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvidenceGalleryScreen(
                      imageProviders: widget.photos
                          .map((e) => FileImage(File(e.path)))
                          .toList(),
                      initialIndex: index,
                      isEditing: true,
                      onDelete: widget.onPhotoRemoved,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: FileImage(File(photo.path)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(photo.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => widget.onPhotoRemoved(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 3),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.primaryBlack.withValues(
                              alpha: .70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

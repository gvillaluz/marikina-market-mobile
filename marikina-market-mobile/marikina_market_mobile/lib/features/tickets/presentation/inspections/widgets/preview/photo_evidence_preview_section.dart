import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/widgets/evidence_gallery_screen.dart';

class PhotoEvidencePreviewSection extends StatelessWidget {
  final List<XFile> evidences;
  const PhotoEvidencePreviewSection({
    required this.evidences,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primaryLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .25),
            offset: const Offset(-1, 1),
            blurRadius: 3.5,
            spreadRadius: 0,
          )
        ]
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.3,
        ),
        itemCount: evidences.length,
        itemBuilder: (context, index) {
          final photoUrl = evidences[index];
          
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder:(context) => EvidenceGalleryScreen(
                imageProviders: evidences.map((e) => FileImage(File(e.path))).toList(),
                initialIndex: index,
                isEditing: false,
              ))
            ),
            child: Positioned.fill(
              child: Hero(
                tag: photoUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                      File(photoUrl.path),
                      fit: BoxFit.cover,
                    )
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
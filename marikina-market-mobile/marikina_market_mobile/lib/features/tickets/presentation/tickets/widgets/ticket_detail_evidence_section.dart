import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/widgets/evidence_gallery_screen.dart';

class TicketDetailEvidenceSection extends StatelessWidget {
  final List<String> evidences;
  final bool isTicket;

  const TicketDetailEvidenceSection({
    required this.evidences,
    required this.isTicket,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                imageProviders: evidences.map((e) => CachedNetworkImageProvider(e)).toList(),
                initialIndex: index,
                isEditing: false,
              ))
            ),
            child: Positioned.fill(
              child: Hero(
                tag: CachedNetworkImageProvider(photoUrl), 
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator()
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image, 
                      color: Colors.red,
                    ),
                  )
                )
              ),
            ),
          );
        },
      ),
    );
  }
}
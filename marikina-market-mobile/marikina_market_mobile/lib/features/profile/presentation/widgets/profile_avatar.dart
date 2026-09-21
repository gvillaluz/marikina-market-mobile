import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/profile/data/cache_manager/avatar_cache_manager.dart';
import 'package:marikina_market_mobile/features/profile/domain/enums/avatar_action.dart';

class ProfileAvatar extends StatefulWidget {
  final String? profileUrl;
  final ValueChanged<XFile> onChangePhoto;
  final VoidCallback onRemovePhoto;
  const ProfileAvatar({
    this.profileUrl,
    required this.onChangePhoto,
    required this.onRemovePhoto,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _cachedAvatar;

  @override
  void initState() {
    super.initState();
    _loadCachedAvatar();
  }

  Future<void> _loadCachedAvatar() async {
    final cached = await AvatarCacheManager.instance.getFileFromCache(
      'user_avatar',
    );

    if (!mounted) return;

    setState(() {
      _cachedAvatar = cached?.file;
    });
  }

  bool get _hasPhoto =>
      widget.profileUrl != null && widget.profileUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    Future<void> changeProfilePicture() async {
      final photo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (photo == null) return;

      widget.onChangePhoto(photo);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 40,
            child: _hasPhoto
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.profileUrl!,
                      cacheManager: AvatarCacheManager.instance,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(strokeWidth: 2.5),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person, size: 40),
                    ),
                  )
                : _cachedAvatar != null
                ? Image.file(
                    _cachedAvatar!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person, size: 40),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: PopupMenuButton<AvatarAction>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: AvatarAction.changePhoto,
                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Icon(Icons.camera_alt, size: 20, color: AppColors.primary),
                    SizedBox(width: 10),
                    Text(_hasPhoto ? 'Change Photo' : 'Add Photo'),
                  ],
                ),
              ),
              if (_hasPhoto)
                const PopupMenuItem(
                  value: AvatarAction.removePhoto,
                  child: Row(
                    children: [
                      SizedBox(width: 5),

                      Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10),
                      Text('Remove Photo'),
                    ],
                  ),
                ),
            ],
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.primaryLight, width: 5),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.primaryLight,
                size: 12,
              ),
            ),
            onSelected: (action) {
              switch (action) {
                case AvatarAction.changePhoto:
                  changeProfilePicture();
                  break;

                case AvatarAction.removePhoto:
                  setState(() => _cachedAvatar = null);
                  widget.onRemovePhoto();
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/profile_detail_item.dart';

class ProfileHeaderCard extends StatelessWidget {
  final User user;
  final ValueChanged<XFile> onChangePhoto;
  final VoidCallback onRemovePhoto;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.onChangePhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                ProfileAvatar(
                  profileUrl: user.profileUrl,
                  onChangePhoto: onChangePhoto,
                  onRemovePhoto: onRemovePhoto,
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.lastName}, ${user.firstName}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      child: Row(
                        spacing: 2,
                        children: [
                          Icon(
                            Icons.gpp_good,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          Text(
                            user.role.value.toString().toUpperCase(),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Market Public Market Office',
                      style: TextStyle(color: AppColors.mediumGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 30,
              children: [
                ProfileDetailItem(
                  label: 'User ID',
                  value: user.username,
                  iconData: Icons.contact_mail_outlined,
                ),
                ProfileDetailItem(
                  label: 'Member Since',
                  value: DateTimeFormatter.getDate(user.createdAt),
                  iconData: Icons.calendar_today,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

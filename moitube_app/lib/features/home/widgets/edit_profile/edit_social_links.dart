import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/screens/edit_profile_screen.dart'; // For SocialLinkItem

class EditSocialLinks extends StatelessWidget {
  final List<SocialLinkItem> socialLinks;
  final VoidCallback onAddLink;
  final Function(int) onRemoveLink;

  const EditSocialLinks({
    super.key,
    required this.socialLinks,
    required this.onAddLink,
    required this.onRemoveLink,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Liên kết',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: onAddLink,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: const Text(
                'Thêm liên kết',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF262626),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...List.generate(socialLinks.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: socialLinks[index].type,
                      dropdownColor: const Color(0xFF1A1A1A),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: [
                        'Website',
                        'Facebook',
                        'TikTok',
                        'Instagram',
                        'Youtube',
                      ].map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          )).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          socialLinks[index].type = val;
                          (context as Element).markNeedsBuild(); // Force rebuild
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        socialLinks[index].url = val;
                      },
                      controller: TextEditingController(
                        text: socialLinks[index].url,
                      )..selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: socialLinks[index].url.length,
                          ),
                        ),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'https://...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => onRemoveLink(index),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

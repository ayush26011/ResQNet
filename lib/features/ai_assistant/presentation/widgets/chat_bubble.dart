import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingLG),
              decoration: BoxDecoration(
                color: isUser
                    ? (isDark ? AppColors.deepMint.withOpacity(0.2) : AppColors.mintGreen)
                    : (isDark ? AppColors.darkCard : AppColors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.neuDarkMode.withOpacity(0.8)
                        : AppColors.neuDark.withOpacity(0.25),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: isDark
                        ? AppColors.neuLightDarkMode.withOpacity(0.2)
                        : AppColors.neuLight.withOpacity(0.9),
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content.isEmpty && message.status == MessageStatus.generating
                        ? 'Thinking...'
                        : message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: AppTextStyles.captionText.copyWith(
                          fontSize: 9,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textTertiary,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.status == MessageStatus.sending
                              ? Icons.schedule_rounded
                              : Icons.done_all_rounded,
                          size: 11,
                          color: AppColors.deepMint,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser
            ? const LinearGradient(
                colors: [AppColors.deepMint, AppColors.deepAqua],
              )
            : const LinearGradient(
                colors: [AppColors.deepBlue, AppColors.deepAqua],
              ),
        boxShadow: [
          BoxShadow(
            color: (isUser ? AppColors.deepMint : AppColors.deepBlue).withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: isUser
            ? const Icon(Icons.person_rounded, color: Colors.white, size: 18)
            : const Icon(Icons.psychology_rounded, color: Colors.white, size: 18),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

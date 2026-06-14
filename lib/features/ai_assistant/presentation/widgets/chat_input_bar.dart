import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isGenerating;
  final bool isDark;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.isGenerating,
    required this.isDark,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isGenerating) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : AppColors.warmCream,
        border: Border(
          top: BorderSide(
            color: widget.isDark ? AppColors.darkCardElevated : AppColors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.darkCard : AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDark
                          ? AppColors.neuDarkMode.withOpacity(0.5)
                          : AppColors.neuDark.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 4,
                  minLines: 1,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: widget.isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _hasText && !widget.isGenerating ? _submit : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: _hasText && !widget.isGenerating
                      ? AppColors.mintGradient
                      : null,
                  color: _hasText && !widget.isGenerating
                      ? null
                      : (widget.isDark ? AppColors.darkCardElevated : AppColors.softBeige),
                  boxShadow: _hasText && !widget.isGenerating
                      ? [
                          BoxShadow(
                            color: AppColors.deepMint.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  widget.isGenerating ? Icons.hourglass_empty_rounded : Icons.send_rounded,
                  color: _hasText && !widget.isGenerating
                      ? Colors.white
                      : AppColors.textTertiary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

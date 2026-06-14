import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/ai_assistant_provider.dart';
import '../../domain/chat_message_model.dart';
import '../../data/local_model_manager.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/model_status_card.dart';
import '../widgets/suggested_prompt_chips.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _sideloadDirPath;
  bool _showStatusCard = true;

  @override
  void initState() {
    super.initState();
    _loadSideloadPath();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _loadSideloadPath() async {
    final path = await LocalModelManager.instance.getModelDirectoryPath();
    if (mounted) {
      setState(() {
        _sideloadDirPath = path;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = ref.watch(chatHistoryProvider);
    final status = ref.watch(modelStatusProvider);
    final config = ref.watch(llmConfigProvider);
    final repo = ref.read(chatbotRepositoryProvider);

    ref.listen<List<ChatMessage>>(chatHistoryProvider, (prev, next) {
      if (next.length > (prev?.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    final isGenerating = messages.isNotEmpty && messages.last.status == MessageStatus.generating;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.warmCream,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.warmCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.mintGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ResQNet AI',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Offline Assistant',
                  style: AppTextStyles.captionText.copyWith(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showStatusCard ? Icons.info_rounded : Icons.info_outline_rounded,
              color: AppColors.deepMint,
            ),
            onPressed: () => setState(() => _showStatusCard = !_showStatusCard),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Clear Chat',
            onPressed: () {
              ref.read(chatHistoryProvider.notifier).clearChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                if (_showStatusCard)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ModelStatusCard(
                      status: status,
                      resolvedPath: repo.resolvedModelPath,
                      errorMessage: repo.lastErrorMessage,
                      modelName: config.modelDisplayName,
                      sideloadDirectoryPath: _sideloadDirPath,
                      isDark: isDark,
                    ),
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.05),
                if (messages.isEmpty)
                  _buildEmptyState(isDark)
                else
                  ...messages.map((msg) {
                    if (msg.role == MessageRole.assistant &&
                        msg.content.isEmpty &&
                        msg.status == MessageStatus.generating) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.deepBlue, AppColors.deepAqua],
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.psychology_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const TypingIndicator(),
                            ),
                          ],
                        ),
                      );
                    }
                    return ChatBubble(message: msg, isDark: isDark);
                  }).toList(),
              ],
            ),
          ),
          if (messages.isEmpty)
            SuggestedPromptChips(
              onTapPrompt: (prompt) {
                ref.read(chatHistoryProvider.notifier).sendMessage(prompt);
              },
              isDark: isDark,
            ),
          ChatInputBar(
            onSend: (text) {
              ref.read(chatHistoryProvider.notifier).sendMessage(text);
            },
            isGenerating: isGenerating,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.neuDarkMode.withOpacity(0.6) : AppColors.neuDark.withOpacity(0.2),
                    blurRadius: 18,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: AppColors.deepMint,
                size: 44,
              ),
            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              'Offline AI Assistant',
              style: AppTextStyles.headlineLarge.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask me questions, get step-by-step emergency guidance, learn safety protocols, or ask anything you need. Works 100% offline without internet.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/neumorphic_card.dart';
import '../../data/local_model_manager.dart';
import '../../domain/ai_assistant_provider.dart';

class ModelStatusCard extends ConsumerStatefulWidget {
  final ModelStatus status;
  final String? resolvedPath;
  final String? errorMessage;
  final String modelName;
  final String? sideloadDirectoryPath;
  final bool isDark;

  const ModelStatusCard({
    super.key,
    required this.status,
    required this.resolvedPath,
    required this.errorMessage,
    required this.modelName,
    required this.sideloadDirectoryPath,
    required this.isDark,
  });

  @override
  ConsumerState<ModelStatusCard> createState() => _ModelStatusCardState();
}

class _ModelStatusCardState extends ConsumerState<ModelStatusCard> {
  final TextEditingController _pathController = TextEditingController();
  bool _isWorking = false;
  String? _operationFeedback;

  @override
  void initState() {
    super.initState();
    _loadCustomPath();
  }

  Future<void> _loadCustomPath() async {
    final customPath = await LocalModelManager.instance.getCustomModelPath();
    if (customPath != null && mounted) {
      _pathController.text = customPath;
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomPath() async {
    setState(() {
      _isWorking = true;
      _operationFeedback = null;
    });

    final path = _pathController.text.trim();
    await LocalModelManager.instance.setCustomModelPath(path.isEmpty ? null : path);
    
    // Reload model status
    await ref.read(modelStatusProvider.notifier).initModel();

    if (mounted) {
      setState(() {
        _isWorking = false;
        _operationFeedback = path.isEmpty 
            ? 'Custom path cleared.' 
            : 'Custom path configured successfully!';
      });
    }
  }

  Future<void> _importModel() async {
    try {
      setState(() {
        _isWorking = true;
        _operationFeedback = 'Opening file picker...';
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // GGUF is a custom extension, pick any and validate magic bytes
      );

      if (result == null || result.files.isEmpty || result.files.single.path == null) {
        setState(() {
          _isWorking = false;
          _operationFeedback = 'Import cancelled.';
        });
        return;
      }

      final sourcePath = result.files.single.path!;
      
      setState(() {
        _operationFeedback = 'Validating and copying GGUF model file...';
      });

      final success = await LocalModelManager.instance.importModelFile(sourcePath);

      // Reload model status
      await ref.read(modelStatusProvider.notifier).initModel();

      if (mounted) {
        setState(() {
          _isWorking = false;
          if (success) {
            _operationFeedback = 'Model imported and loaded successfully!';
            _pathController.clear();
          } else {
            _operationFeedback = 'Import failed: ${LocalModelManager.instance.lastErrorMessage}';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isWorking = false;
          _operationFeedback = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (widget.status) {
      case ModelStatus.ready:
        statusColor = AppColors.successGreen;
        statusText = 'Model Ready';
        statusIcon = Icons.check_circle_rounded;
        break;
      case ModelStatus.loading:
        statusColor = AppColors.warningAmber;
        statusText = 'Loading Model...';
        statusIcon = Icons.hourglass_top_rounded;
        break;
      case ModelStatus.importing:
        statusColor = AppColors.warningAmber;
        statusText = 'Importing Model...';
        statusIcon = Icons.downloading_rounded;
        break;
      case ModelStatus.loadFailed:
        statusColor = AppColors.emergencyRed;
        statusText = 'Model Load Failed';
        statusIcon = Icons.error_rounded;
        break;
      case ModelStatus.invalid:
        statusColor = AppColors.emergencyRed;
        statusText = 'Model Invalid';
        statusIcon = Icons.cancel_rounded;
        break;
      case ModelStatus.missing:
        statusColor = AppColors.emergencyRed;
        statusText = 'Model Missing';
        statusIcon = Icons.warning_amber_rounded;
        break;
    }

    return NeumorphicCard(
      padding: const EdgeInsets.all(AppConstants.paddingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.modelName,
                      style: AppTextStyles.captionText.copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Text(
            'To use the offline AI assistant:',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Place model file (tinyllama-1.1b-chat-q4_k_m.gguf) in app storage or select/import it below.',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: widget.isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),

          if (widget.sideloadDirectoryPath != null) ...[
            const SizedBox(height: 8),
            Text(
              'Default App Directory:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: widget.isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.darkCardElevated : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.isDark ? AppColors.neuLightDarkMode.withOpacity(0.4) : AppColors.divider,
                  width: 0.5,
                ),
              ),
              child: SelectableText(
                widget.sideloadDirectoryPath!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9.5,
                  color: AppColors.deepMint,
                ),
              ),
            ),
          ],

          if (widget.status == ModelStatus.ready && widget.resolvedPath != null) ...[
            const SizedBox(height: 10),
            Text(
              'Running locally from path:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              widget.resolvedPath!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 9.5,
                color: AppColors.successGreen,
              ),
            ),
          ],

          if (widget.errorMessage != null && widget.status != ModelStatus.ready) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.emergencyRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.errorMessage!,
                style: AppTextStyles.captionText.copyWith(
                  color: AppColors.emergencyRed,
                  fontSize: 10,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Text(
            'Configurable Model Path / Import:',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.isDark ? AppColors.darkCardElevated : AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.isDark ? AppColors.darkCard : AppColors.divider,
                      width: 0.5,
                    ),
                  ),
                  child: TextField(
                    controller: _pathController,
                    decoration: InputDecoration(
                      hintText: 'Enter absolute GGUF path...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isWorking ? null : _saveCustomPath,
                  icon: const Icon(Icons.save_rounded, size: 14),
                  label: const Text('Configure Path', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isWorking ? null : _importModel,
                  icon: const Icon(Icons.file_open_rounded, size: 14),
                  label: const Text('Import Model', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepMint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),

          if (_operationFeedback != null) ...[
            const SizedBox(height: 10),
            Text(
              _operationFeedback!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _operationFeedback!.contains('success') || _operationFeedback!.contains('loaded')
                    ? AppColors.successGreen
                    : AppColors.warningAmber,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

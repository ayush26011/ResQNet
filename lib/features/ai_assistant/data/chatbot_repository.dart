import 'dart:async';
import '../domain/chat_message_model.dart';
import 'local_llm_config.dart';
import 'local_model_manager.dart';
import 'offline_llm_service.dart';

class ChatbotRepository {
  final OfflineLlmService _llmService = OfflineLlmServiceImpl();

  ModelStatus get modelStatus => LocalModelManager.instance.status;
  String? get resolvedModelPath => LocalModelManager.instance.resolvedModelPath;
  String? get lastErrorMessage => LocalModelManager.instance.lastErrorMessage;

  Future<ModelStatus> initModel(LocalLlmConfig config) async {
    final status = await LocalModelManager.instance.checkModelStatus(config.modelFileName);
    if (status == ModelStatus.ready) {
      final path = LocalModelManager.instance.resolvedModelPath;
      if (path != null) {
        try {
          await _llmService.initModel(path, config);
        } catch (e) {
          LocalModelManager.instance.setStatus(ModelStatus.loadFailed, 'Failed to load GGUF model: ${e.toString()}');
        }
      } else {
        LocalModelManager.instance.setStatus(ModelStatus.invalid, 'Model path resolved to null.');
      }
    }
    return LocalModelManager.instance.status;
  }

  Stream<String> getReplyStream(List<ChatMessage> history, LocalLlmConfig config) {
    if (modelStatus != ModelStatus.ready) {
      return Stream.value('Error: Offline AI model not ready (current status: $modelStatus). ${lastErrorMessage ?? ""}');
    }
    return _llmService.generateResponseStream(history, config);
  }

  Future<void> dispose() async {
    await _llmService.dispose();
  }
}

import 'dart:async';
import 'package:llm_core/llm_core.dart';
import 'package:llm_llamacpp/llm_llamacpp.dart';
import '../domain/chat_message_model.dart';
import 'local_llm_config.dart';
import 'offline_llm_service_interface.dart';
import 'offline_prompt_builder.dart';

class OfflineLlmServiceImpl implements OfflineLlmService {
  LlamaCppChatRepository? _repository;

  @override
  Future<void> initModel(String modelPath, LocalLlmConfig config) async {
    await dispose();
    _repository = LlamaCppChatRepository(
      contextSize: config.contextSize,
      nGpuLayers: 0, // Max CPU compatibility
    );
    await _repository!.loadModel(modelPath);
  }

  @override
  Stream<String> generateResponseStream(List<ChatMessage> history, LocalLlmConfig config) {
    final repo = _repository;
    if (repo == null) {
      return Stream.value('Error: Offline AI model not initialized.');
    }

    final promptMessages = OfflinePromptBuilder.buildPrompt(history);
    
    try {
      final controller = StreamController<String>();
      
      final stream = repo.streamChat(
        'model',
        messages: promptMessages,
      );

      StreamSubscription? subscription;
      subscription = stream.listen(
        (chunk) {
          final text = chunk.message?.content;
          if (text != null) {
            controller.add(text);
          }
        },
        onError: (err) {
          controller.addError(err);
          controller.close();
        },
        onDone: () {
          controller.close();
        },
      );

      controller.onCancel = () {
        subscription?.cancel();
      };

      return controller.stream;
    } catch (e) {
      return Stream.value('Error during generation: ${e.toString()}');
    }
  }

  @override
  Future<void> dispose() async {
    _repository = null;
  }
}

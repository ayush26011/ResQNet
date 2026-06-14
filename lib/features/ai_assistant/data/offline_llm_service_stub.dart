import '../domain/chat_message_model.dart';
import 'local_llm_config.dart';
import 'offline_llm_service_interface.dart';

class OfflineLlmServiceImpl implements OfflineLlmService {
  @override
  Future<void> initModel(String modelPath, LocalLlmConfig config) async {
    // No-op on web
  }

  @override
  Stream<String> generateResponseStream(List<ChatMessage> history, LocalLlmConfig config) {
    return Stream.value(
      'Offline LLM is available on Android/Desktop builds. Web preview cannot run native GGUF inference.'
    );
  }

  @override
  Future<void> dispose() async {
    // No-op
  }
}

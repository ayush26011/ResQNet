import '../domain/chat_message_model.dart';
import 'local_llm_config.dart';

abstract class OfflineLlmService {
  Future<void> initModel(String modelPath, LocalLlmConfig config);
  Stream<String> generateResponseStream(List<ChatMessage> history, LocalLlmConfig config);
  Future<void> dispose();
}

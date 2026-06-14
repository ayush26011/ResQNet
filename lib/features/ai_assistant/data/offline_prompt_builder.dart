import 'package:llm_core/llm_core.dart';
import '../domain/chat_message_model.dart';

class OfflinePromptBuilder {
  static const String systemInstruction = '''
You are ResQNet Offline Assistant, an on-device emergency and general knowledge assistant.
You work completely offline.
Answer calmly, clearly, and practically.
Support Hindi, English, and Hinglish.
Reply in the same language as the user.
For emergency, medical, disaster, safety, and survival questions, give step-by-step guidance.
Do not pretend to contact emergency services.
If the situation is serious, advise the user to contact local emergency help if possible.
Keep answers concise but useful.
''';

  static List<LLMMessage> buildPrompt(List<ChatMessage> history) {
    final List<LLMMessage> messages = [];

    // Add system instructions
    messages.add(
      LLMMessage(
        role: LLMRole.system,
        content: systemInstruction,
      ),
    );

    // Map history to LLMMessage
    for (final msg in history) {
      if (msg.status == MessageStatus.error || msg.status == MessageStatus.sending) {
        continue;
      }
      LLMRole llmRole;
      switch (msg.role) {
        case MessageRole.user:
          llmRole = LLMRole.user;
          break;
        case MessageRole.assistant:
          llmRole = LLMRole.assistant;
          break;
        case MessageRole.system:
          llmRole = LLMRole.system;
          break;
      }
      messages.add(
        LLMMessage(
          role: llmRole,
          content: msg.content,
        ),
      );
    }

    return messages;
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chatbot_repository.dart';
import '../data/local_llm_config.dart';
import '../data/local_model_manager.dart';
import 'chat_message_model.dart';

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  final repo = ChatbotRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

final llmConfigProvider = StateProvider<LocalLlmConfig>((ref) {
  return const LocalLlmConfig(
    modelFileName: 'tinyllama-1.1b-chat-q4_k_m.gguf',
    modelDisplayName: 'TinyLlama 1.1B Chat (Q4_K_M)',
  );
});

class ModelStatusNotifier extends StateNotifier<ModelStatus> {
  final ChatbotRepository _repository;
  final Ref _ref;

  ModelStatusNotifier(this._repository, this._ref) : super(ModelStatus.missing) {
    initModel();
  }

  Future<void> initModel() async {
    state = ModelStatus.loading;
    final config = _ref.read(llmConfigProvider);
    final result = await _repository.initModel(config);
    state = result;
  }
}

final modelStatusProvider = StateNotifierProvider<ModelStatusNotifier, ModelStatus>((ref) {
  final repo = ref.watch(chatbotRepositoryProvider);
  return ModelStatusNotifier(repo, ref);
});

class ChatHistoryNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatbotRepository _repository;
  final Ref _ref;
  StreamSubscription<String>? _replySubscription;

  ChatHistoryNotifier(this._repository, this._ref) : super([]);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = [...state, userMessage];

    // Create assistant message placeholder
    final assistantMessageId = (DateTime.now().microsecondsSinceEpoch + 1).toString();
    final assistantPlaceholder = ChatMessage(
      id: assistantMessageId,
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      status: MessageStatus.generating,
    );

    state = [...state, assistantPlaceholder];

    final config = _ref.read(llmConfigProvider);
    
    // Cancel any previous subscriptions
    await _replySubscription?.cancel();

    // Stream reply
    final stream = _repository.getReplyStream(state.sublist(0, state.length - 1), config);
    
    final StringBuffer buffer = StringBuffer();
    _replySubscription = stream.listen(
      (chunk) {
        buffer.write(chunk);
        state = [
          for (final msg in state)
            if (msg.id == assistantMessageId)
              msg.copyWith(content: buffer.toString(), status: MessageStatus.generating)
            else
              msg
        ];
      },
      onError: (err) {
        state = [
          for (final msg in state)
            if (msg.id == assistantMessageId)
              msg.copyWith(
                content: 'Error: ${err.toString()}',
                status: MessageStatus.error,
              )
            else
              msg
        ];
      },
      onDone: () {
        state = [
          for (final msg in state)
            if (msg.id == assistantMessageId)
              msg.copyWith(status: MessageStatus.complete)
            else
              msg
        ];
      },
    );
  }

  void clearChat() {
    _replySubscription?.cancel();
    state = [];
  }

  @override
  void dispose() {
    _replySubscription?.cancel();
    super.dispose();
  }
}

final chatHistoryProvider = StateNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>((ref) {
  final repo = ref.watch(chatbotRepositoryProvider);
  return ChatHistoryNotifier(repo, ref);
});
